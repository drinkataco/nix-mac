return function()
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
    "python",
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
    tsx = { "typescriptreact" },
    yaml = { "yml" },
  }

  local filetypes = vim.deepcopy(languages)
  for _, aliases in pairs(fenced_language_aliases) do
    vim.list_extend(filetypes, aliases)
  end

  local treesitter = require("nvim-treesitter")
  -- Avoid kicking off duplicate installs when multiple buffers hit the same
  -- missing parser during startup.
  local installing = {}

  local function start_parser(bufnr, parser)
    if not vim.api.nvim_buf_is_valid(bufnr) then
      return false
    end

    if not pcall(vim.treesitter.language.add, parser) then
      return false
    end

    return pcall(vim.treesitter.start, bufnr, parser)
  end

  local function retry_start(bufnr, parser, attempts)
    if start_parser(bufnr, parser) or attempts <= 0 then
      installing[parser] = nil
      return
    end

    vim.defer_fn(function()
      retry_start(bufnr, parser, attempts - 1)
    end, 200)
  end

  for parser, aliases in pairs(fenced_language_aliases) do
    vim.treesitter.language.register(parser, aliases)
  end

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("settings_treesitter", { clear = true }),
    pattern = filetypes,
    callback = function(args)
      local filetype = vim.bo[args.buf].filetype
      local parser = vim.treesitter.language.get_lang(filetype) or filetype

      if not start_parser(args.buf, parser) then
        if not installing[parser] then
          installing[parser] = true

          vim.schedule(function()
            -- Install missing parsers on demand, then retry attaching
            -- Treesitter for the buffer that triggered the install.
            treesitter.install(parser, { summary = true })
            retry_start(args.buf, parser, 30)
          end)
        end

        return
      end
    end,
  })
end
