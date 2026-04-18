return function()
  -- Docs: https://github.com/lukas-reineke/indent-blankline.nvim
  -- This is the Neovim-native replacement for indentLine. It uses virtual text instead of conceal.
  require("ibl").setup({
    indent = {
      char = "┊",
    },
    scope = {
      enabled = false,
    },
  })
end
