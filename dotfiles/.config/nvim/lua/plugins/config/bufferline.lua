return function()
  -- Docs: https://github.com/akinsho/bufferline.nvim
  local function has_session_file()
    return vim.fn.findfile("Session.vim", ".;") ~= ""
  end

  local function padded_name(tab)
    local width = 15
    local name_width = vim.fn.strdisplaywidth(tab.name)

    if name_width >= width then
      return " " .. tab.name
    end

    return " " .. tab.name .. string.rep(" ", width - name_width)
  end

  require("bufferline").setup({
    options = {
      -- Projects restored by vim-obsession have a Session.vim file; keep the
      -- tabline visible there, but hide single throwaway tabs elsewhere.
      always_show_bufferline = has_session_file(),
      diagnostics = "nvim_lsp",
      max_name_length = 16,
      mode = "tabs",
      name_formatter = padded_name,
      tab_size = 0,
      hover = {
        enabled = true,
        delay = 50,
        reveal = { "close" },
      },
    },
  })
end
