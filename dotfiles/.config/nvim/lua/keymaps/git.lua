local map = vim.keymap.set

-- Keep Git mappings close to Fugitive and terminal-first workflows.
map("n", "<leader>gg", "<cmd>Git<CR>", { desc = "Git status" })
map("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git status" })
map("n", "<leader>gb", "<cmd>Git blame<CR>", { desc = "Git blame" })
map("n", "<leader>gd", "<cmd>Gvdiffsplit<CR>", { desc = "Git diff split" })
map("n", "<leader>g2", "<cmd>diffget //2<CR>", { desc = "Use left diff version" })
map("n", "<leader>g3", "<cmd>diffget //3<CR>", { desc = "Use right diff version" })
map("n", "<leader>gp", "<cmd>diffput<CR>", { desc = "Push current diff changes" })
map("n", "<leader>ga", "<cmd>Git add %<CR>", { desc = "Git add current file" })
map("n", "<leader>gc", "<cmd>BCommits<CR>", { desc = "Buffer commits" })
map("n", "<leader>gx", "<cmd>tabnew | terminal lazygit<CR>", { desc = "Open lazygit" })
map("n", "<leader>gl", "<cmd>tabnew | terminal lazygit<CR>", { desc = "Open lazygit" })
