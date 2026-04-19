local map = vim.keymap.set

-- Netrw/Vinegar remains useful for quick split/tab file browsing.
map("n", "<leader>e", "<cmd>Explore<CR>", { desc = "Explore files" })
map("n", "<leader>ev", "<cmd>Vexplore<CR>", { desc = "Explore files in vsplit" })
map("n", "<leader>eh", "<cmd>Sexplore<CR>", { desc = "Explore files in split" })
map("n", "<leader>et", "<cmd>Texplore<CR>", { desc = "Explore files in new tab" })

-- Tab-page shortcuts that are easy to reach and easy to remember.
map("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "<leader>to", "<cmd>tabonly<CR>", { desc = "Close other tabs" })
map("n", "<leader>tq", "<cmd>tabclose<CR>", { desc = "Close tab" })
map("n", "<leader>th", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
map("n", "<leader>tl", "<cmd>tabnext<CR>", { desc = "Next tab" })
