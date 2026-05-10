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

  local filename = {
    function()
      if vim.bo.filetype == "noice" and vim.bo.buftype == "nofile" then
        return "Messages"
      end

      local path = vim.api.nvim_buf_get_name(0)
      if path ~= "" then
        local root = vim.fs.root(0, { ".git" })
        if root then
          return vim.fs.relpath(root, path) or path
        end

        return vim.fn.fnamemodify(path, ":p")
      end

      return "[No Name]"
    end,
  }

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

  local recording_status = {
    function()
      local register = vim.fn.reg_recording()
      if register == "" then
        return ""
      end

      return string.format("󰻂 recording @%s", register)
    end,
  }

  local recording_refresh_group = vim.api.nvim_create_augroup("lualine_recording_status", { clear = true })
  vim.api.nvim_create_autocmd("RecordingEnter", {
    group = recording_refresh_group,
    callback = function()
      require("lualine").refresh({ place = { "statusline" } })
    end,
  })
  vim.api.nvim_create_autocmd("RecordingLeave", {
    group = recording_refresh_group,
    callback = function()
      vim.schedule(function()
        require("lualine").refresh({ place = { "statusline" } })
      end)
    end,
  })

  require("lualine").setup({
    options = {
      theme = "auto",
      globalstatus = true,
      section_separators = {
        left = "",
        right = "",
      },
      component_separators = "",
      disabled_filetypes = { "lazy" },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = { filename, lsp_status, recording_status },
      lualine_x = { diff, diagnostics, filetype },
      lualine_y = {},
      lualine_z = {},
    },
  })
end
