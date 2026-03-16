local api = vim.api

-- Autocmd groups let us replace and reload related event hooks cleanly.
local autoread = api.nvim_create_augroup("settings_autoread", { clear = true })
api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  group = autoread,
  -- Check whether files changed on disk when returning to Neovim or entering a buffer.
  command = "checktime",
})

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
  command = "set nohlsearch",
})
