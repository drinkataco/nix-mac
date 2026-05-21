return function()
  local popup_border = {
    style = "rounded",
    padding = { 0, 1 },
  }

  local popup_winhighlight = {
    Normal = "Normal",
    FloatBorder = "DiagnosticInfo",
  }

  vim.keymap.set("n", "<Esc>", function()
    require("noice").cmd("dismiss")
  end, { desc = "Dismiss notifications" })

  require("noice").setup({
    cmdline = {
      enabled = true,
      view = "cmdline",
    },
    messages = {
      enabled = true,
      view = "mini",
      view_error = "mini",
      view_warn = "mini",
      view_history = "messages",
    },
    routes = {
      {
        filter = {
          event = "lsp",
          kind = { "progress", "message" },
          find = "[Pp]yright",
        },
        opts = { skip = true },
      },
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
      cmdline_output_to_split = false,
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
      -- Keep command prompts in a predictable stack so DAP confirm/input
      -- dialogs remain visible at the same time.
      cmdline_popup = {
        zindex = 200,
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
      cmdline_input = {
        view = "cmdline_popup",
        zindex = 220,
        position = {
          row = 9,
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
      cmdline_popupmenu = {
        relative = "editor",
        zindex = 230,
        position = {
          row = 12,
          col = "50%",
        },
        size = {
          width = 100,
          height = "auto",
          max_height = 10,
        },
        border = popup_border,
        win_options = {
          winhighlight = popup_winhighlight,
        },
      },
      popupmenu = {
        zindex = 210,
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
      mini = {
        align = "message-left",
        timeout = 5000,
        zindex = 200,
        position = {
          row = -1,
          col = 0,
        },
        win_options = {
          winblend = 0,
        },
      },
    },
  })
end
