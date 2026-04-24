local map = vim.keymap.set
local nvim_docs = require("commands.nvim_docs")
local markdown_links = vim.api.nvim_create_augroup("keymaps_markdown_links", { clear = true })

-- Keep a forgiving write command around for muscle memory
vim.api.nvim_create_user_command("W", "write", {})

vim.api.nvim_create_user_command("NvimDocs", nvim_docs.toggle, {})

-- In markdown buffers, let <CR> follow local TOC-style anchor links while
-- preserving normal Enter behaviour everywhere else.
vim.api.nvim_create_autocmd("FileType", {
  group = markdown_links,
  pattern = "markdown",
  callback = function(args)
    vim.keymap.set("n", "<CR>", function()
      if not nvim_docs.jump_anchor(args.buf) and not nvim_docs.open_link(args.buf) then
        vim.cmd("normal! <CR>")
      end
    end, { buffer = args.buf, silent = true, desc = "Open markdown link" })
  end,
})

-- Format the current buffer through conform.nvim when available.
map("n", "<leader>p", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })
map("n", "<leader>h", "<cmd>NvimDocs<CR>", { desc = "Open Neovim notes" })
