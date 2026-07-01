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
opt.cmdheight = 0
opt.showmode = false
opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.scrolloff = 4
opt.termguicolors = true
opt.undofile = true
opt.updatetime = 750
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
opt.completeopt = { "menu", "menuone", "noselect" }
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldenable = true
opt.foldlevel = 99
opt.foldlevelstart = 99
-- Let Treesitter rebuild folds on open instead of restoring stale fold state from sessions.
opt.sessionoptions:remove("folds")
-- Keep folds and cursor/window state in per-file views when using :mkview/:loadview.
opt.viewoptions = { "cursor", "folds", "slash", "unix" }

-- Explicitly enable Neovim's built-in EditorConfig support
vim.g.editorconfig = true

-- Filetype overrides
vim.filetype.add({
  filename = {
    [".yamllint"] = "yaml",
  },
})

-- Netrw
g.netrw_banner = 0
