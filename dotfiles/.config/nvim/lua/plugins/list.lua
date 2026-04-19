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
  {
    "NMAC427/guess-indent.nvim",
    event = "BufReadPre",
    config = function()
      require("guess-indent").setup({})
    end,
  },

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
        "<leader>xs",
        function()
          require("trouble").toggle({
            mode = "symbols",
            focus = false,
            win = {
              position = "right",
              wo = {
                wrap = true,
                linebreak = true,
              },
            },
          })
        end,
        desc = "Document symbols",
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

  -- Testing
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
      "fredrikaverpil/neotest-golang",
    },
    keys = {
      {
        "<leader>nr",
        function()
          require("neotest").run.run()
        end,
        desc = "Run nearest test",
      },
      {
        "<leader>nf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run test file",
      },
      {
        "<leader>ns",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle test summary",
      },
      {
        "<leader>no",
        function()
          require("neotest").output.open({ enter = true })
        end,
        desc = "Open test output",
      },
      {
        "<leader>np",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Toggle test output panel",
      },
      {
        "<leader>nx",
        function()
          require("neotest").run.stop()
        end,
        desc = "Stop test run",
      },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-golang"),
        },
      })
    end,
  },

  -- AI assistance
  {
    "olimorris/codecompanion.nvim",
    version = "^18.0.0",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = {
      "CodeCompanion",
      "CodeCompanionActions",
      "CodeCompanionChat",
      "CodeCompanionCLI",
      "CodeCompanionCmd",
    },
    keys = {
      {
        "<leader>aa",
        "<cmd>CodeCompanionActions<CR>",
        desc = "AI actions",
      },
      {
        "<leader>ac",
        "<cmd>CodeCompanionChat Toggle<CR>",
        desc = "AI chat",
      },
      {
        "<leader>ai",
        "<cmd>CodeCompanion<CR>",
        desc = "AI inline",
      },
      {
        "<leader>ai",
        ":'<,'>CodeCompanion<CR>",
        desc = "AI inline selection",
        mode = "v",
      },
    },
    config = config.codecompanion,
  },
}
