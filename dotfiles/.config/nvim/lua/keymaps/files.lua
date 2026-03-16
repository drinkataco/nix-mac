local map = vim.keymap.set

-- Netrw/Vinegar still gives a lightweight file browser without adding another tree plugin.
map("n", "<leader>e", "<cmd>Explore<CR>", { desc = "Explore files" })
map("n", "<leader>ev", "<cmd>Vexplore<CR>", { desc = "Explore files in vsplit" })
map("n", "<leader>eh", "<cmd>Sexplore<CR>", { desc = "Explore files in split" })
map("n", "<leader>et", "<cmd>Texplore<CR>", { desc = "Explore files in new tab" })
