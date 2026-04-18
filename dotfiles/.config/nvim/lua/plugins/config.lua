local M = {}

local skip = {
  icons = true,
}

-- Discover per-plugin config modules from Neovim's runtimepath.
local config_dir
for _, runtime_path in ipairs(vim.api.nvim_list_runtime_paths()) do
  local candidate = runtime_path .. "/lua/plugins/config"
  if vim.fn.isdirectory(candidate) == 1 then
    config_dir = candidate
    break
  end
end

assert(config_dir, "Could not find lua/plugins/config on runtimepath")

-- Load every per-plugin config as config.<filename>; for example,
-- lua/plugins/config/lualine.lua becomes require("plugins.config").lualine.
for _, path in ipairs(vim.fn.glob(config_dir .. "/*.lua", true, true)) do
  local name = vim.fn.fnamemodify(path, ":t:r")
  if not skip[name] then
    M[name] = require("plugins.config." .. name)
  end
end

M.lazy = {
  install = {
    colorscheme = { "default" },
  },
  checker = {
    enabled = false,
  },
}

return M
