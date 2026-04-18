return function()
  -- Docs: https://github.com/lewis6991/gitsigns.nvim
  require("gitsigns").setup({
    current_line_blame = false,
    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "-" },
      topdelete = { text = "-" },
      changedelete = { text = "~" },
      untracked = { text = "+" },
    },
  })
end
