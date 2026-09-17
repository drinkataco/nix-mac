return function()
  -- Docs: https://github.com/jmbuhr/otter.nvim
  -- Attaches language servers to code embedded inside YAML (e.g. Kubernetes
  -- ConfigMaps whose `.data` keys hold nested YAML documents or CSS). Relies
  -- on treesitter injections defined in after/queries/yaml/injections.scm.
  local otter = require("otter")

  otter.setup({
    handle_leading_whitespace = true,
    lsp = {
      diagnostic_update_events = { "BufWritePost", "InsertLeave", "TextChanged" },
    },
    buffers = {
      set_filetype = true,
      write_to_disk = false,
    },
  })

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("otter_yaml", { clear = true }),
    pattern = { "yaml", "helm" },
    callback = function()
      -- languages, completion, diagnostics, tsquery
      pcall(otter.activate, { "yaml", "css" }, true, true, nil)
    end,
  })
end
