local diagnostic_signs = require("plugins.config.icons").diagnostics

return function()
  -- Based on https://github.com/hieulw/nvimrc/blob/HEAD/lua/plugins/ui/statusline.lua
  local icons = {
    diagnostics = {
      Error = diagnostic_signs.ERROR .. " ",
      Warning = diagnostic_signs.WARN .. " ",
      Info = diagnostic_signs.INFO .. " ",
      Hint = diagnostic_signs.HINT .. " ",
    },
    git = {
      LineAdded = "",
      LineModified = "",
      LineRemoved = "",
    },
    ui = {
      LSP = "",
    },
    spinner = { "", "", "", "", "", "", "", "", "", "", "", "", "" },
  }

  local filetype = { "filetype", icon_only = true }

  local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    sections = { "error", "warn", "info", "hint" },
    symbols = {
      error = icons.diagnostics.Error,
      hint = icons.diagnostics.Hint,
      info = icons.diagnostics.Info,
      warn = icons.diagnostics.Warning,
    },
    colored = true,
    update_in_insert = false,
    always_visible = false,
  }

  local diff = {
    "diff",
    source = function()
      local gitsigns = vim.b.gitsigns_status_dict
      if gitsigns then
        return {
          added = gitsigns.added,
          modified = gitsigns.changed,
          removed = gitsigns.removed,
        }
      end
    end,
    symbols = {
      added = icons.git.LineAdded .. " ",
      modified = icons.git.LineModified .. " ",
      removed = icons.git.LineRemoved .. " ",
    },
    colored = true,
    always_visible = false,
  }

  local lsp_status = {
    "lsp_status",
    icon = icons.ui.LSP,
    symbols = {
      spinner = icons.spinner,
      done = "",
      separator = " ",
    },
    ignore_lsp = {},
    show_name = true,
  }

  require("lualine").setup({
    options = {
      theme = "auto",
      globalstatus = true,
      section_separators = "",
      component_separators = "",
      disabled_filetypes = { "lazy" },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = {},
      lualine_c = { "filename", lsp_status },
      lualine_x = { diff, diagnostics, filetype },
      lualine_y = {},
      lualine_z = {},
    },
  })
end
