return function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok_cmp_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok_cmp_lsp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end

  local diagnostic_signs = require("plugins.config.icons").diagnostics
  local diagnostic_float = {
    border = "rounded",
    focusable = false,
    scope = "cursor",
  }

  vim.diagnostic.config({
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = diagnostic_signs.ERROR,
        [vim.diagnostic.severity.WARN] = diagnostic_signs.WARN,
        [vim.diagnostic.severity.INFO] = diagnostic_signs.INFO,
        [vim.diagnostic.severity.HINT] = diagnostic_signs.HINT,
      },
    },
    float = diagnostic_float,
  })

  local map = vim.keymap.set
  local on_attach = function(_, bufnr)
    local opts = { buffer = bufnr }

    -- These are the core LSP motions worth standardising early.
    map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
    map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "List references" }))
    map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
    map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
    map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
    -- Open the same bordered float immediately after moving so diagnostic
    -- navigation and CursorHold use one consistent presentation.
    map("n", "[d", function()
      vim.diagnostic.goto_prev({ float = diagnostic_float })
    end, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
    map("n", "]d", function()
      vim.diagnostic.goto_next({ float = diagnostic_float })
    end, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
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
