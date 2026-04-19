return function()
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
          cwd = function()
            return vim.fs.dirname(vim.fs.dirname(vim.fs.dirname(eslint)))
          end,
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
