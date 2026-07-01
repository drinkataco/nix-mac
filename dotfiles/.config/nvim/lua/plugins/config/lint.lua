return function()
  local lint = require("lint")

  lint.linters_by_ft = {
    yaml = { "yamllint" },
  }

  vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("settings_lint", { clear = true }),
    callback = function()
      lint.try_lint()
    end,
  })
end
