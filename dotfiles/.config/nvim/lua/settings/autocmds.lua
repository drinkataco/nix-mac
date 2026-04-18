local api = vim.api

-- Views only make sense for normal file buffers; skip prompts, terminals, and scratch buffers.
local function can_persist_view(bufnr)
  if vim.bo[bufnr].buftype ~= "" then
    return false
  end

  local name = vim.api.nvim_buf_get_name(bufnr)
  return name ~= ""
end

-- Autocmd groups let us replace and reload related event hooks cleanly.
local autoread = api.nvim_create_augroup("settings_autoread", { clear = true })
api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  group = autoread,
  -- Check whether files changed on disk when returning to Neovim or entering a buffer.
  command = "checktime",
})

-- Ensure writes to new nested paths do not fail because parent directories are missing.
local mkdir = api.nvim_create_augroup("settings_mkdir", { clear = true })
api.nvim_create_autocmd("BufWritePre", {
  group = mkdir,
  callback = function(args)
    -- Create missing parent directories before saving a new file.
    local dir = vim.fn.fnamemodify(args.match, ":p:h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

-- Search highlighting should only stay on while actively using / or ?.
local search = api.nvim_create_augroup("settings_search_highlight", { clear = true })
api.nvim_create_autocmd("CmdlineEnter", {
  group = search,
  pattern = { "/", "?" },
  -- Only highlight matches while actively searching.
  command = "set hlsearch",
})
api.nvim_create_autocmd("CmdlineLeave", {
  group = search,
  pattern = { "/", "?" },
  -- Drop search highlighting once the command-line search ends.
  command = "set nohlsearch",
})

-- tmux config filenames are not detected consistently enough without a manual filetype hint.
local tmux = api.nvim_create_augroup("settings_tmux_filetype", { clear = true })
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = tmux,
  pattern = { ".tmux.conf", "*.tmux", "tmux.conf" },
  callback = function()
    vim.bo.filetype = "tmux"
  end,
})

-- Treesitter folds can come back stale after session restore; refreshing them on
-- open keeps structured files foldable without having to reset the whole window.
local folds = api.nvim_create_augroup("settings_fold_refresh", { clear = true })
api.nvim_create_autocmd({ "BufWinEnter", "FileType" }, {
  group = folds,
  pattern = { "json", "yaml", "javascript", "typescript", "typescriptreact", "tsx", "rust", "sh", "bash" },
  callback = function()
    vim.schedule(function()
      pcall(vim.cmd.normal, { args = { "zx" }, bang = true })
    end)
  end,
})

-- Persist per-file folds and cursor position across close/reopen using views.
local views = api.nvim_create_augroup("settings_views", { clear = true })
api.nvim_create_autocmd("BufWinLeave", {
  group = views,
  callback = function(args)
    if not can_persist_view(args.buf) then
      return
    end

    pcall(vim.cmd, "silent! mkview")
  end,
})
api.nvim_create_autocmd("BufWinEnter", {
  group = views,
  callback = function(args)
    if not can_persist_view(args.buf) then
      return
    end

    pcall(vim.cmd, "silent! loadview")
  end,
})

-- Show the diagnostic message when the cursor rests on an errored span.
local diagnostics = api.nvim_create_augroup("settings_diagnostics", { clear = true })
api.nvim_create_autocmd("CursorHold", {
  group = diagnostics,
  callback = function()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local row, col = cursor[1], cursor[2]
    local line = row - 1
    local cursor_diagnostics = vim.diagnostic.get(0, { lnum = line })
    local has_cursor_diagnostic = vim.iter(cursor_diagnostics):any(function(diagnostic)
      local end_col = diagnostic.end_col or diagnostic.col
      return col >= diagnostic.col and col <= end_col
    end)

    if not has_cursor_diagnostic then
      return
    end

    vim.diagnostic.open_float(nil, {
      focus = false,
      scope = "cursor",
    })
  end,
})
