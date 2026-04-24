local map = vim.keymap.set

-- Keep a forgiving write command around for muscle memory
vim.api.nvim_create_user_command("W", "write", {})

local function open_nvim_docs()
  local path = vim.fn.expand("~/projects/nix-mac/docs/nvim.md")
  if vim.fn.filereadable(path) == 0 then
    vim.notify("Missing docs file: " .. path, vim.log.levels.ERROR)
    return
  end

  local buf = vim.fn.bufadd(path)
  vim.fn.bufload(buf)

  local width = math.min(math.floor(vim.o.columns * 0.8), 120)
  local height = math.min(math.floor(vim.o.lines * 0.8), 40)
  local row = math.floor((vim.o.lines - height) / 2) - 1
  local col = math.floor((vim.o.columns - width) / 2)

  -- Open the real docs buffer in a disposable float. Using the actual file
  -- buffer keeps normal search, marks, and syntax behaviour intact, while the
  -- local window options make it behave like a quick-reference overlay.
  local win = vim.api.nvim_open_win(buf, true, require("settings.ui").float({
    relative = "editor",
    width = width,
    height = height,
    row = math.max(row, 0),
    col = math.max(col, 0),
    style = "minimal",
  }))

  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].buflisted = false
  vim.bo[buf].modifiable = false
  vim.bo[buf].readonly = true
  vim.wo[win].wrap = true
  vim.wo[win].linebreak = true
  vim.wo[win].cursorline = false
end

vim.api.nvim_create_user_command("NvimDocs", open_nvim_docs, {})

-- Format the current buffer through conform.nvim when available.
map("n", "<leader>p", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })
map("n", "<leader>fn", "<cmd>NvimDocs<CR>", { desc = "Open Neovim notes" })
