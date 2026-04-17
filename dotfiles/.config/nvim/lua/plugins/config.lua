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

  -- Markdown fenced code blocks often use short names or editor-specific labels.
  -- Register the common ones we actually use so Treesitter can inject the right parser.
  local fenced_language_aliases = {
    bash = { "sh", "shell", "zsh" },
    javascript = { "js" },
    json = { "jsonc" },
    typescript = { "ts" },
    yaml = { "yml" },
  }

  require("nvim-treesitter").install(languages)

  for parser, aliases in pairs(fenced_language_aliases) do
    vim.treesitter.language.register(parser, aliases)
  end

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
  local ok_cmp_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok_cmp_lsp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end
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

  vim.lsp.config("gopls", {
    capabilities = capabilities,
    on_attach = on_attach,
  })

  vim.lsp.config("helm_ls", {
    capabilities = capabilities,
    on_attach = on_attach,
  })

  vim.lsp.config("lua_ls", {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          checkThirdParty = false,
        },
      },
    },
  })

  vim.lsp.config("marksman", {
    capabilities = capabilities,
    on_attach = on_attach,
  })

  vim.lsp.config("nixd", {
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

  -- TypeScript completion depends on a language server; cmp only renders the results.
  vim.lsp.config("ts_ls", {
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },
    root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
    single_file_support = true,
  })

  vim.lsp.config("jsonls", {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = {
          enable = true,
        },
      },
    },
  })

  vim.lsp.config("rust_analyzer", {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
        },
        checkOnSave = true,
      },
    },
  })

  vim.lsp.config("pyright", {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "openFilesOnly",
          useLibraryCodeForTypes = true,
        },
      },
    },
  })

  vim.lsp.config("taplo", {
    capabilities = capabilities,
    on_attach = on_attach,
  })

  vim.lsp.config("terraformls", {
    capabilities = capabilities,
    on_attach = on_attach,
  })

  vim.lsp.enable("bashls")
  vim.lsp.enable("gopls")
  vim.lsp.enable("helm_ls")
  vim.lsp.enable("jsonls")
  vim.lsp.enable("lua_ls")
  vim.lsp.enable("marksman")
  vim.lsp.enable("nixd")
  vim.lsp.enable("pyright")
  vim.lsp.enable("rust_analyzer")
  vim.lsp.enable("taplo")
  vim.lsp.enable("terraformls")
  vim.lsp.enable("ts_ls")
  vim.lsp.enable("yamlls")
end

M.cmp = function()
  -- Docs: https://github.com/hrsh7th/nvim-cmp
  local cmp = require("cmp")
  local luasnip = require("luasnip")

  require("luasnip.loaders.from_vscode").lazy_load()

  cmp.setup({
    completion = {
      completeopt = "menu,menuone,noselect",
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<CR>"] = cmp.mapping.confirm({ select = false }),
      ["<C-e>"] = cmp.mapping.abort(),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip", keyword_length = 2 },
      { name = "path" },
    }, {
      { name = "buffer" },
    }),
  })

  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
    },
  })

  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
  })
end

M.conform = function()
  -- Docs: https://github.com/stevearc/conform.nvim
  -- Keep formatting lightweight and tool-driven instead of bolting on a heavier lint stack early
  local function find_project_file(ctx, names)
    return vim.fs.find(names, {
      path = vim.fs.dirname(ctx.filename),
      upward = true,
    })[1]
  end

  require("conform").setup({
    formatters_by_ft = {
      bash = { "shfmt" },
      css = { "prettier" },
      go = { "gofmt" },
      hcl = { "tofu_fmt" },
      html = { "prettier" },
      javascript = { "project_eslint", "prettier" },
      javascriptreact = { "project_eslint", "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      lua = { "stylua" },
      markdown = { "prettier" },
      nix = { "nixfmt" },
      python = { "ruff_format" },
      rust = { "rustfmt" },
      sh = { "shfmt" },
      toml = { "taplo" },
      terraform = { "tofu_fmt" },
      ["terraform-vars"] = { "tofu_fmt" },
      tsx = { "project_eslint", "prettier" },
      typescript = { "project_eslint", "prettier" },
      typescriptreact = { "project_eslint", "prettier" },
      yaml = { "prettier" },
    },
    formatters = {
      project_eslint = function(bufnr)
        local filename = vim.api.nvim_buf_get_name(bufnr)
        local ctx = { filename = filename }
        local eslint = find_project_file(ctx, { "node_modules/.bin/eslint" })

        if eslint == nil or find_project_file(ctx, {
            ".eslintrc",
            ".eslintrc.cjs",
            ".eslintrc.js",
            ".eslintrc.json",
            ".eslintrc.yaml",
            ".eslintrc.yml",
            "eslint.config.cjs",
            "eslint.config.js",
            "eslint.config.mjs",
          }) == nil then
          return nil
        end

        return {
          command = eslint,
          args = { "--fix", "$FILENAME" },
          cwd = vim.fs.dirname(vim.fs.dirname(vim.fs.dirname(eslint))),
          stdin = false,
        }
      end,
      tofu_fmt = {
        command = "tofu",
        args = { "fmt", "-" },
        stdin = true,
      },
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

M.gitsigns = function()
  -- Docs: https://github.com/lewis6991/gitsigns.nvim
  require("gitsigns").setup({
    current_line_blame = false,
    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "-" },
      topdelete = { text = "-" },
      changedelete = { text = "~" },
      untracked = { text = "+" },
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
