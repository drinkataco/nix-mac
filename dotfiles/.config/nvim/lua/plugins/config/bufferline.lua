return function()
  -- Docs: https://github.com/akinsho/bufferline.nvim
  require("bufferline").setup({
    options = {
      diagnostics = "nvim_lsp",
      mode = "tabs",
      hover = {
        enabled = true,
        delay = 50,
        reveal = { "close" },
      },
    },
  })
end
