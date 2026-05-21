return function()
  require("neogen").setup({
    languages = {
      typescript = {
        template = { annotation_convention = "tsdoc" },
      },
      typescriptreact = {
        template = { annotation_convention = "tsdoc" },
      },
    },
  })
end
