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
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = config.lualine,
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
      "onsails/lspkind.nvim",
      "rafamadriz/friendly-snippets",
    },
    config = config.cmp,
  },
  {
    "stevearc/conform.nvim",
    config = config.conform,
  },
  {
    "folke/trouble.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<CR>",
        desc = "Workspace diagnostics",
      },
      {
        "<leader>xb",
        "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
        desc = "Buffer diagnostics",
      },
      {
        "<leader>xq",
        "<cmd>Trouble qflist toggle<CR>",
        desc = "Quickfix list",
      },
      {
        "<leader>xl",
        "<cmd>Trouble loclist toggle<CR>",
        desc = "Location list",
      },
    },
    opts = {},
  },
  { "towolf/vim-helm" },
}
