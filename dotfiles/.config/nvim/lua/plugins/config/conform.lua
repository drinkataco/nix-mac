return function()
  -- Docs: https://github.com/stevearc/conform.nvim
  -- Keep formatting lightweight and tool-driven instead of bolting on a heavier lint stack early
  local function find_project_file(ctx, names)
    return vim.fs.find(names, {
      path = vim.fs.dirname(ctx.filename),
      upward = true,
    })[1]
  end

  local function eslint_config(ctx)
    return find_project_file(ctx, {
      ".eslintrc",
      ".eslintrc.cjs",
      ".eslintrc.js",
      ".eslintrc.json",
      ".eslintrc.yaml",
      ".eslintrc.yml",
      "eslint.config.cjs",
      "eslint.config.js",
      "eslint.config.mjs",
    })
  end

  local function eslint_root(eslint)
    return vim.fs.dirname(vim.fs.dirname(vim.fs.dirname(eslint)))
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
      typescript = { "prettier", "project_eslint" },
      typescriptreact = { "prettier", "project_eslint" },
      yaml = { "prettier" },
    },
    formatters = {
      project_eslint = function(bufnr)
        local filename = vim.api.nvim_buf_get_name(bufnr)
        local ctx = { filename = filename }
        local eslint = find_project_file(ctx, { "node_modules/.bin/eslint" })

        if eslint == nil or eslint_config(ctx) == nil then
          return nil
        end

        return {
          format = function(_, format_ctx, lines, callback)
            vim.system(
              {
                eslint,
                "--fix-dry-run",
                "--stdin",
                "--stdin-filename",
                format_ctx.filename,
                "--format",
                "json",
              },
              {
                cwd = eslint_root(eslint),
                stdin = table.concat(lines, "\n"),
                text = true,
              },
              vim.schedule_wrap(function(result)
                if result.code ~= 0 and result.code ~= 1 then
                  callback(result.stderr ~= "" and result.stderr or result.stdout)
                  return
                end

                local ok, decoded = pcall(vim.json.decode, result.stdout)
                if not ok or type(decoded) ~= "table" or type(decoded[1]) ~= "table" then
                  callback(result.stderr ~= "" and result.stderr or "ESLint returned invalid JSON")
                  return
                end

                if decoded[1].output == nil then
                  callback(nil, lines)
                  return
                end

                local output = vim.split(decoded[1].output, "\n", { plain = true })
                if output[#output] == "" then
                  table.remove(output)
                end

                callback(nil, output)
              end)
            )
          end,
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
