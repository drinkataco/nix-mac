local api = vim.api

-- Only open the hover float when the cursor is actually resting on a diagnostic.
-- This keeps CursorHold useful without spraying empty floats around the editor.
local diagnostics = api.nvim_create_augroup("settings_diagnostics", { clear = true })
api.nvim_create_autocmd("CursorHold", {
  group = diagnostics,
  callback = function()
    local cursor = api.nvim_win_get_cursor(0)
    local row, col = cursor[1], cursor[2]
    local line = row - 1
    local cursor_diagnostics = vim.diagnostic.get(0, { lnum = line })
    local has_cursor_diagnostic = vim.iter(cursor_diagnostics):any(function(diagnostic)
      local end_col = diagnostic.end_col or diagnostic.col
      return col >= diagnostic.col and col <= end_col
    end)

    if has_cursor_diagnostic then
      vim.diagnostic.open_float(nil, {
        border = "rounded",
        focus = false,
        scope = "cursor",
      })
    end
  end,
})

local eslint_namespace = api.nvim_create_namespace("settings_eslint")
local eslint_filetypes = {
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
  tsx = true,
}

local eslint_severity = {
  [1] = vim.diagnostic.severity.WARN,
  [2] = vim.diagnostic.severity.ERROR,
}

local function find_project_file(filename, names)
  return vim.fs.find(names, {
    path = vim.fs.dirname(filename),
    upward = true,
  })[1]
end

local function eslint_config(filename)
  return find_project_file(filename, {
    ".eslintrc",
    ".eslintrc.cjs",
    ".eslintrc.js",
    ".eslintrc.json",
    ".eslintrc.yaml",
    ".eslintrc.yml",
    "eslint.config.cjs",
    "eslint.config.js",
    "eslint.config.mjs",
    "eslint.config.ts",
  })
end

local function eslint_binary(filename)
  return find_project_file(filename, { "node_modules/.bin/eslint" })
end

local function eslint_root(eslint)
  return vim.fs.dirname(vim.fs.dirname(vim.fs.dirname(eslint)))
end

-- Trouble, the built-in float, and sign rendering all expect plain diagnostic
-- tables. Normalising ESLint JSON here keeps those consumers insulated from the
-- formatter-specific payload shape.
local function eslint_diagnostics(messages)
  local diagnostics = {}

  for _, message in ipairs(messages or {}) do
    if message.line ~= nil and message.column ~= nil then
      local lnum = math.max(message.line - 1, 0)
      local col = math.max(message.column - 1, 0)
      local end_lnum = lnum
      local end_col = col + 1

      if message.endLine ~= nil then
        end_lnum = math.max(message.endLine - 1, lnum)
      end

      if message.endColumn ~= nil then
        end_col = math.max(message.endColumn - 1, col + 1)
      end

      diagnostics[#diagnostics + 1] = {
        source = "eslint",
        lnum = lnum,
        col = col,
        end_lnum = end_lnum,
        end_col = end_col,
        severity = eslint_severity[message.severity] or vim.diagnostic.severity.INFO,
        message = message.message,
        code = message.ruleId and tostring(message.ruleId) or nil,
      }
    end
  end

  return diagnostics
end

-- Run the project's own ESLint so diagnostics match its local config/plugins
-- instead of a global tool that may disagree with the repo.
local function lint_eslint(bufnr)
  if not api.nvim_buf_is_valid(bufnr) then
    return
  end

  local filename = api.nvim_buf_get_name(bufnr)
  if filename == "" or not eslint_filetypes[vim.bo[bufnr].filetype] then
    vim.diagnostic.reset(eslint_namespace, bufnr)
    return
  end

  local eslint = eslint_binary(filename)
  local config = eslint_config(filename)
  if eslint == nil or config == nil then
    vim.diagnostic.reset(eslint_namespace, bufnr)
    return
  end

  local changedtick = api.nvim_buf_get_changedtick(bufnr)
  local content = table.concat(api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n")

  vim.system(
    {
      eslint,
      "--stdin",
      "--stdin-filename",
      filename,
      "--format",
      "json",
    },
    {
      cwd = eslint_root(eslint),
      stdin = content,
      text = true,
    },
    vim.schedule_wrap(function(result)
      if not api.nvim_buf_is_valid(bufnr) or api.nvim_buf_get_changedtick(bufnr) ~= changedtick then
        return
      end

      if result.code ~= 0 and result.code ~= 1 then
        vim.diagnostic.reset(eslint_namespace, bufnr)
        return
      end

      local ok, decoded = pcall(vim.json.decode, result.stdout)
      if not ok or type(decoded) ~= "table" or type(decoded[1]) ~= "table" then
        vim.diagnostic.reset(eslint_namespace, bufnr)
        return
      end

      vim.diagnostic.set(eslint_namespace, bufnr, eslint_diagnostics(decoded[1].messages))
    end)
  )
end

local eslint = api.nvim_create_augroup("settings_eslint", { clear = true })
api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = eslint,
  callback = function(args)
    lint_eslint(args.buf)
  end,
})
