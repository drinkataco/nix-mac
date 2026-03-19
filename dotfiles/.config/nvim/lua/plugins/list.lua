local config = require("plugins.config")

return {
  -- Git and editor workflow
  { "tpope/vim-fugitive" },
  { "tpope/vim-rhubarb" },
  {
    "lewis6991/gitsigns.nvim",
    config = config.gitsigns,
  },
  { "christoomey/vim-tmux-navigator" },
  { "tpope/vim-obsession" },
  { "tpope/vim-vinegar" },
  { "editorconfig/editorconfig-vim" },

  -- Fuzzy finding
  { "junegunn/fzf", build = "./install --bin" },
  { "junegunn/fzf.vim" },

  -- Syntax and visual structure
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },
  { "nvim-tree/nvim-web-devicons" },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = config.bufferline,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = config.indent_blankline,
  },

  -- Language support
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
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
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "rafamadriz/friendly-snippets",
    },
    config = config.cmp,
  },
  {
    "stevearc/conform.nvim",
    config = config.conform,
  },
  { "towolf/vim-helm" },
}
