local config = require("plugins.config")

return {
  -- Git and editor workflow
  { "tpope/vim-fugitive" },
  { "tpope/vim-rhubarb" },
  { "christoomey/vim-tmux-navigator" },
  { "tpope/vim-vinegar" },
  { "editorconfig/editorconfig-vim" },

  -- Fuzzy finding
  { "junegunn/fzf", build = "./install --bin" },
  { "junegunn/fzf.vim" },

  -- Syntax and visual structure
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = config.indent_blankline,
  },

  -- Language support
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = config.treesitter,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "b0o/SchemaStore.nvim",
    },
    config = config.lsp,
  },
  {
    "stevearc/conform.nvim",
    config = config.conform,
  },
  { "towolf/vim-helm" },
}
