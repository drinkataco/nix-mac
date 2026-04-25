local api = vim.api

-- Views only make sense for normal file buffers; prompts, terminals, and scratch
-- buffers either cannot be restored sanely or create noisy view files.
local function can_persist_view(bufnr)
  if vim.bo[bufnr].buftype ~= "" then
    return false
  end

  return api.nvim_buf_get_name(bufnr) ~= ""
end

-- Re-check files when Neovim regains focus so external edits show up promptly.
local autoread = api.nvim_create_augroup("settings_autoread", { clear = true })
api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  group = autoread,
  command = "checktime",
})

-- Allow writing new nested files without creating each parent directory by hand.
local mkdir = api.nvim_create_augroup("settings_mkdir", { clear = true })
api.nvim_create_autocmd("BufWritePre", {
  group = mkdir,
  callback = function(args)
    local dir = vim.fn.fnamemodify(args.match, ":p:h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

-- Search highlighting should only remain active while a / or ? search is in flight.
local search = api.nvim_create_augroup("settings_search_highlight", { clear = true })
api.nvim_create_autocmd("CmdlineEnter", {
  group = search,
  pattern = { "/", "?" },
  command = "set hlsearch",
})
api.nvim_create_autocmd("CmdlineLeave", {
  group = search,
  pattern = { "/", "?" },
  command = "set nohlsearch",
})

local command_line_view
local hide_command_line = false

-- Show a real command row while entering commands, then hide it again after
-- the next normal editor action. Keeping the row around briefly after
-- `CmdlineLeave` lets `:echo`, errors, and other command output remain visible,
-- but leaving the current window should still collapse it immediately.
local command_line = api.nvim_create_augroup("settings_command_line", { clear = true })
api.nvim_create_autocmd("CmdlineEnter", {
  group = command_line,
  callback = function()
    local cmdtype = vim.fn.getcmdtype()
    hide_command_line = false
    command_line_view = (cmdtype == ":") and vim.fn.winsaveview() or nil
    vim.opt.cmdheight = 1
    if command_line_view ~= nil then
      vim.schedule(function()
        if command_line_view ~= nil then
          pcall(vim.fn.winrestview, command_line_view)
        end
      end)
    end
  end,
})
api.nvim_create_autocmd("CmdlineLeave", {
  group = command_line,
  callback = function()
    hide_command_line = true
  end,
})
api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufEnter", "WinLeave", "FocusLost" }, {
  group = command_line,
  callback = function()
    if not hide_command_line then
      return
    end

    local view = command_line_view or vim.fn.winsaveview()
    hide_command_line = false
    vim.schedule(function()
      vim.opt.cmdheight = 0
      pcall(vim.fn.winrestview, view)
      command_line_view = nil
    end)
  end,
})

-- tmux filenames are inconsistent enough that an explicit hint is more reliable
-- than relying on filetype detection to guess correctly every time.
local tmux = api.nvim_create_augroup("settings_tmux_filetype", { clear = true })
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = tmux,
  pattern = { ".tmux.conf", "*.tmux", "tmux.conf" },
  callback = function()
    vim.bo.filetype = "tmux"
  end,
})

-- Treesitter-backed folds can come back stale after session restore; `zx`
-- refreshes them without resetting the rest of the window state.
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

-- Persist folds and cursor position across reopen for real file buffers only.
local views = api.nvim_create_augroup("settings_views", { clear = true })
api.nvim_create_autocmd("BufWinLeave", {
  group = views,
  callback = function(args)
    if can_persist_view(args.buf) then
      pcall(vim.cmd, "silent! mkview")
    end
  end,
})
api.nvim_create_autocmd("BufWinEnter", {
  group = views,
  callback = function(args)
    if can_persist_view(args.buf) then
      pcall(vim.cmd, "silent! loadview")
    end
  end,
})
