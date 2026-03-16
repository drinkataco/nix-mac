-- Use an explicit Neovim-native colourscheme instead of deriving one from shell state.
vim.cmd.colorscheme("kanagawa-paper")

-- Highlight the current line to make the cursor easier to track
vim.opt.cursorline = true

-- Don't let conceal hide characters while moving around in normal mode
vim.opt.concealcursor:remove("n")

-- Make error text stand out clearly without filling the whole line
vim.api.nvim_set_hl(0, "Error", {
  bold = true,
  underline = true,
  fg = "#EC5f67",
  bg = "NONE",
})

-- Subtle current-line highlight to help track the cursor in config-heavy files
vim.api.nvim_set_hl(0, "CursorLine", {
  bg = "#1b2b34",
})

-- Give the current line number a little more emphasis than surrounding numbers
vim.api.nvim_set_hl(0, "CursorLineNr", {
  bold = true,
})
