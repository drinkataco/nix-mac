return function()
  require("snacks").setup({
    picker = {
      enabled = true,
      ui_select = true,
      sources = {
        select = {
          layout = {
            preset = "select",
          },
        },
      },
    },
  })
end
