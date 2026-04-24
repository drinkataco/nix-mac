return function()
  require("render-markdown").setup({
    file_types = { "markdown" },
    overrides = {
      buflisted = {
        [false] = {
          anti_conceal = {
            enabled = false,
          },
        },
      },
    },
  })
end
