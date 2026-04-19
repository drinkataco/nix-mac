return function()
  -- Docs: https://github.com/akinsho/bufferline.nvim
  require("bufferline").setup({
    options = {
      always_show_bufferline = false,
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
