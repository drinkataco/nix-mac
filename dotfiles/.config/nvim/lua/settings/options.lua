local opt = vim.opt
local g = vim.g

-- File handling
opt.autoread = true
opt.swapfile = false
opt.clipboard = "unnamedplus"
opt.fileformats = { "unix", "dos", "mac" }

-- Indentation
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- Interface
opt.number = true
opt.numberwidth = 2
opt.mouse = "a"
opt.mousemoveevent = true
opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.scrolloff = 4
opt.termguicolors = true
opt.undofile = true
opt.list = true
opt.listchars = {
  tab = "|·",
  trail = "~",
  extends = ">",
  precedes = "<",
}
opt.wildignore:append({ "*.DS_Store", "*.pyc" })
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldenable = true
opt.foldlevel = 99
opt.foldlevelstart = 99

-- Netrw
g.netrw_banner = 0
