local map = vim.keymap.set

-- Keep a forgiving write command around for muscle memory
vim.api.nvim_create_user_command("W", "write", {})

-- Format the current buffer through conform.nvim when available.
map("n", "<leader>p", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })
