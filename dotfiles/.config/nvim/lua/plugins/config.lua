local M = {}

M.treesitter = function()
  -- Docs: https://github.com/nvim-treesitter/nvim-treesitter
  -- Treesitter carries most of the language-aware editing weight for config-heavy repos.
  local languages = {
    "bash",
    "comment",
    "diff",
    "dockerfile",
    "git_config",
    "gitcommit",
    "gitignore",
    "go",
    "gomod",
    "gosum",
    "helm",
    "hcl",
    "javascript",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "regex",
    "rust",
    "toml",
    "tmux",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
  }

  require("nvim-treesitter").install(languages)

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("settings_treesitter", { clear = true }),
    pattern = languages,
    callback = function()
      local ok = pcall(vim.treesitter.start)
      if not ok then
        return
      end
    end,
  })
end

M.lsp = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local map = vim.keymap.set
  local on_attach = function(_, bufnr)
    local opts = { buffer = bufnr }

    -- These are the core LSP motions worth standardising early.
    map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
    map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "List references" }))
    map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
    map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
    map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
    map("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
    map("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
  end

  -- Docs:
  --   https://github.com/neovim/nvim-lspconfig
  --   https://github.com/b0o/SchemaStore.nvim
  -- Bash is still worth wiring through LSP for scripts, shell glue, and completions
  vim.lsp.config("bashls", {
    capabilities = capabilities,
    on_attach = on_attach,
  })

  -- YAML LSP plus SchemaStore is the main payoff here for Kubernetes and related config.
  vim.lsp.config("yamlls", {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      yaml = {
        schemaStore = {
          enable = false,
          url = "",
        },
        -- SchemaStore provides a broad catalogue of useful YAML schemas, including Kubernetes-adjacent ones.
        schemas = require("schemastore").yaml.schemas(),
        validate = true,
        format = {
          enable = true,
        },
        keyOrdering = false,
      },
    },
  })

  vim.lsp.enable("bashls")
  vim.lsp.enable("yamlls")
end

M.conform = function()
  -- Docs: https://github.com/stevearc/conform.nvim
  -- Keep formatting lightweight and tool-driven instead of bolting on a heavier lint stack early
  require("conform").setup({
    formatters_by_ft = {
      bash = { "shfmt" },
      sh = { "shfmt" },
    },
  })
end

M.indent_blankline = function()
  -- Docs: https://github.com/lukas-reineke/indent-blankline.nvim
  -- This is the Neovim-native replacement for indentLine. It uses virtual text instead of conceal.
  require("ibl").setup({
    indent = {
      char = "┊",
    },
    scope = {
      enabled = false,
    },
  })
end

M.bufferline = function()
  -- Docs: https://github.com/akinsho/bufferline.nvim
  require("bufferline").setup({
    options = {
      diagnostics = "nvim_lsp",
      mode = "tabs",
      hover = {
        enabled = true,
        delay = 50,
        reveal = { "close" },
      },
    },
  })
end

M.lazy = {
  install = {
    colorscheme = { "default" },
  },
  checker = {
    enabled = false,
  },
}

return M
