return function()
  require("snacks").setup({
    bigfile = { enabled = true },
    words = { enabled = true },
    gitbrowse = { enabled = true },
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

  vim.keymap.set("n", "<leader>go", function()
    require("snacks").gitbrowse()
  end, { desc = "Open file in browser" })

  vim.keymap.set("n", "]w", function()
    require("snacks").words.jump(1)
  end, { desc = "Next word reference" })

  vim.keymap.set("n", "[w", function()
    require("snacks").words.jump(-1)
  end, { desc = "Prev word reference" })
end
