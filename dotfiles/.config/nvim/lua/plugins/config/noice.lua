return function()
  local popup_border = {
    style = "rounded",
    padding = { 0, 1 },
  }

  local popup_winhighlight = {
    Normal = "Normal",
    FloatBorder = "DiagnosticInfo",
  }

  require("noice").setup({
    cmdline = {
      enabled = true,
      view = "cmdline_popup",
    },
    messages = {
      enabled = true,
      view = "messages",
      view_error = "messages",
      view_warn = "messages",
      view_history = "messages",
    },
    popupmenu = {
      enabled = true,
      backend = "nui",
    },
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      cmdline_output_to_split = true,
      inc_rename = false,
      lsp_doc_border = false,
    },
    commands = {
      history = {
        view = "split",
        opts = { enter = true, format = "details" },
        filter = {},
      },
      all = {
        view = "split",
        opts = { enter = true, format = "details" },
        filter = {},
      },
    },
    views = {
      cmdline_popup = {
        position = {
          row = 5,
          col = "50%",
        },
        size = {
          width = 100,
          height = "auto",
        },
        border = popup_border,
        win_options = {
          winhighlight = popup_winhighlight,
        },
      },
      popupmenu = {
        relative = "editor",
        position = {
          row = 8,
          col = "50%",
        },
        size = {
          width = 100,
          height = 10,
        },
        border = popup_border,
        win_options = {
          winhighlight = popup_winhighlight,
        },
      },
      messages = {
        backend = "split",
        enter = true,
        relative = "editor",
        position = "bottom",
        size = "20%",
        close = {
          keys = { "q", "<Esc>" },
        },
        win_options = {
          winhighlight = { Normal = "NoiceSplit", FloatBorder = "NoiceSplitBorder" },
          wrap = true,
        },
      },
    },
  })
end
