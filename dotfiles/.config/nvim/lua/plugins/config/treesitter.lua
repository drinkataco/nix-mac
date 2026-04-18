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
