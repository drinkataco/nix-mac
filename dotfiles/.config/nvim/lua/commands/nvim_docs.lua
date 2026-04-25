local M = {}

---Convert markdown heading text into the anchor format used by the table of
---contents links in `docs/nvim.md`.
---@param text string
---@return string
local function markdown_anchor(text)
  local anchor = text:lower()
  anchor = anchor:gsub("`", "")
  anchor = anchor:gsub("[%[%]%(%)%{%}!?,.:;/\\\"']", "")
  anchor = anchor:gsub("&", "")
  anchor = anchor:gsub("%s+", "-")
  anchor = anchor:gsub("%-+", "-")
  anchor = anchor:gsub("^%-", "")
  anchor = anchor:gsub("%-$", "")
  return anchor
end

---Extract the markdown link target from the current line when the cursor is on
---or near a standard `[label](target)` style link.
---@return string|nil
local function current_link_target()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1

  for start_col, target in line:gmatch("()!%[[^%]]-%]%(([^)]+)%)") do
    local full = line:match("!%[[^%]]-%]%(" .. vim.pesc(target) .. "%)", start_col)
    if full ~= nil then
      local finish_col = start_col + #full - 1
      if col >= start_col and col <= finish_col then
        return target
      end
    end
  end

  for start_col, target in line:gmatch("()%[[^%]]-%]%(([^)]+)%)") do
    local full = line:match("%[[^%]]-%]%(" .. vim.pesc(target) .. "%)", start_col)
    if full ~= nil then
      local finish_col = start_col + #full - 1
      if col >= start_col and col <= finish_col then
        return target
      end
    end
  end
end

---Normalize a markdown link target into a concrete file path candidate.
---@param target string
---@return string
local function file_target(target)
  local path = target:gsub("#.*$", "")
  path = vim.trim(path)

  -- Handle markdown's `<path with spaces>` form before stripping optional title
  -- text from the common `path "title"` form.
  local bracketed = path:match("^<(.+)>$")
  if bracketed ~= nil then
    path = bracketed
  else
    path = path:match('^([^%s]+)%s+".-"$') or path
    path = path:match("^([^%s]+)%s+'.-'$") or path
  end

  -- Support file references like `/path/to/file.lua:12` or `/path/to/file#L12`
  -- by stripping the position suffix before resolving the filesystem path.
  path = path:gsub("#L%d+[Cc]?%d*$", "")
  path = path:gsub(":%d+:%d+$", "")
  path = path:gsub(":%d+$", "")
  path = path:gsub("%%20", " ")
  return vim.fn.expand(path)
end

---@param path string
---@return boolean
local function is_absolute_path(path)
  return path:sub(1, 1) == "/" or path:match("^%a:[/\\]") ~= nil
end

---Jump from the local markdown anchor link under the cursor to the matching
---heading in the provided buffer.
---@param buf integer
---@return boolean
function M.jump_anchor(buf)
  local anchor = current_link_target()
  if anchor == nil then
    return false
  end

  if not vim.startswith(anchor, "#") then
    return false
  end

  anchor = anchor:gsub("^#", "")

  for lnum, heading in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    local text = heading:match("^#+%s+(.*)$")
    if text ~= nil and markdown_anchor(text) == anchor then
      vim.api.nvim_win_set_cursor(0, { lnum, 0 })
      vim.cmd("normal! zz")
      return true
    end
  end

  vim.notify("No heading found for #" .. anchor, vim.log.levels.WARN)
  return false
end

---Open the markdown link under the cursor. URLs are handed to the system
---opener, while relative file links are opened inside Neovim.
---@param buf integer
---@return boolean
function M.open_link(buf)
  local target = current_link_target()
  if target == nil or vim.startswith(target, "#") then
    return false
  end

  if target:match("^[a-zA-Z][a-zA-Z0-9+.-]*://") then
    return vim.ui.open(target, {}, function(err)
      if err ~= nil then
        vim.notify("Failed to open link: " .. err, vim.log.levels.ERROR)
      end
    end)
  end

  local path = file_target(target)
  if path == "" then
    return false
  end

  local base = vim.fs.dirname(vim.api.nvim_buf_get_name(buf))
  local resolved = vim.fs.normalize(is_absolute_path(path) and path or (base .. "/" .. path))
  if vim.fn.filereadable(resolved) == 0 and vim.fn.isdirectory(resolved) == 0 then
    vim.notify("Link target not found: " .. target, vim.log.levels.WARN)
    return true
  end

  vim.cmd("edit " .. vim.fn.fnameescape(resolved))
  return true
end

---Open `docs/nvim.md` in a centered, read-only floating window that still uses
---the real buffer so search, syntax, and local TOC jumps behave normally.
---@return integer|nil
local function find_open_window()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    local buf = vim.api.nvim_win_get_buf(win)
    if config.relative ~= "" and vim.b[buf].nvim_docs_float == true then
      return win
    end
  end
end

---Open or close the floating `docs/nvim.md` reference window.
function M.toggle()
  local existing = find_open_window()
  if existing ~= nil and vim.api.nvim_win_is_valid(existing) then
    vim.api.nvim_win_close(existing, true)
    return
  end

  local path = vim.fn.expand("~/projects/nix-mac/docs/nvim.md")
  if vim.fn.filereadable(path) == 0 then
    vim.notify("Missing docs file: " .. path, vim.log.levels.ERROR)
    return
  end

  local buf = vim.fn.bufadd(path)
  vim.fn.bufload(buf)

  local width = math.min(math.floor(vim.o.columns * 0.8), 120)
  local height = math.min(math.floor(vim.o.lines * 0.8), 40)
  local row = math.floor((vim.o.lines - height) / 2) - 1
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, require("settings.ui").float({
    relative = "editor",
    width = width,
    height = height,
    row = math.max(row, 0),
    col = math.max(col, 0),
    style = "minimal",
  }))

  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].buflisted = false
  vim.bo[buf].modifiable = false
  vim.bo[buf].readonly = true
  vim.b[buf].nvim_docs_float = true
  vim.wo[win].wrap = true
  vim.wo[win].linebreak = true
  vim.wo[win].cursorline = false

  local close_group = vim.api.nvim_create_augroup("commands_nvim_docs_" .. buf, { clear = true })
  vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    group = close_group,
    buffer = buf,
    once = true,
    callback = function()
      vim.schedule(function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
      end)
    end,
  })

  vim.keymap.set("n", "<CR>", function()
    if not M.jump_anchor(buf) then
      M.open_link(buf)
    end
  end, { buffer = buf, silent = true, desc = "Jump to heading" })
end

M.open = M.toggle

return M
