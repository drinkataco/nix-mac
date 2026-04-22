return function()
  -- Docs: https://github.com/hrsh7th/nvim-cmp
  local cmp = require("cmp")
  local lspkind = require("lspkind")
  local luasnip = require("luasnip")

  require("luasnip.loaders.from_vscode").lazy_load()

  local insert_window = {
    completion = cmp.config.window.bordered({
      border = "rounded",
    }),
    documentation = cmp.config.window.bordered({
      border = "rounded",
    }),
  }

  cmp.setup({
    completion = {
      completeopt = "menu,menuone,noselect",
    },
    formatting = {
      format = lspkind.cmp_format({
        mode = "symbol_text",
        preset = "default",
      }),
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    window = insert_window,
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

  -- Use the same floating completion window in command mode so opening command
  -- suggestions does not reflow the main buffer area.
  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    window = {
      completion = cmp.config.window.bordered({
        border = "rounded",
      }),
    },
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
  })
end
