local map = vim.keymap.set

local function git_or_files()
  local ok = pcall(vim.cmd, "GitFiles")
  if not ok then
    vim.cmd("Files")
  end
end

-- Prefer Git-aware file search, but fall back cleanly outside repositories.
map("n", "<leader><space>", git_or_files, { desc = "Find files" })
map("n", "<leader>ff", git_or_files, { desc = "Find files" })
map("n", "<leader>fa", "<cmd>Files<CR>", { desc = "Find all files" })
map("n", "<leader>fb", "<cmd>Buffers<CR>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Helptags<CR>", { desc = "Search help tags" })
map("n", "<leader>fl", "<cmd>BLines<CR>", { desc = "Search current buffer" })
map("n", "<leader>fr", "<cmd>History<CR>", { desc = "Search recent files" })
map("n", "<leader>fi", "<cmd>Ag<CR>", { desc = "Search project contents" })
map("n", "<leader>/", "<cmd>Ag<CR>", { desc = "Search project contents" })
map("n", "<leader>fc", "<cmd>Commands<CR>", { desc = "Search commands" })
