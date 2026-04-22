local function require_runtime_modules(pattern)
  local seen = {}
  local files = vim.api.nvim_get_runtime_file(pattern, true)

  table.sort(files)

  -- Load each settings module from runtimepath so dropping in a new file under
  -- lua/settings/autocmds/ is enough to activate it after restart/reload.
  for _, file in ipairs(files) do
    local module = file:match("/lua/(.+)%.lua$")
    if module ~= nil then
      module = module:gsub("/", ".")
      if not seen[module] then
        seen[module] = true
        require(module)
      end
    end
  end
end

require("settings.options")
require_runtime_modules("lua/settings/autocmds/*.lua")
