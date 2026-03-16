-- Use an explicit Neovim-native colourscheme instead of deriving one from shell state.
vim.cmd.colorscheme("tokyonight")

local function darken(hex, amount)
  local value = hex and hex:match("^#(%x%x)(%x%x)(%x%x)$")
  if not value then
    return hex
  end

  local r, g, b = hex:match("^#(%x%x)(%x%x)(%x%x)$")
  local channels = {
    tonumber(r, 16),
    tonumber(g, 16),
    tonumber(b, 16),
  }

  for i, channel in ipairs(channels) do
    channels[i] = math.max(0, math.floor(channel * (1 - amount)))
  end

  return string.format("#%02x%02x%02x", channels[1], channels[2], channels[3])
end

-- Highlight the current line to make the cursor easier to track
vim.opt.cursorline = true

-- Don't let conceal hide characters while moving around in normal mode
vim.opt.concealcursor:remove("n")

-- Make error text stand out clearly without filling the whole line
vim.api.nvim_set_hl(0, "Error", {
  bold = true,
  underline = true,
  fg = "#EC5f67",
  bg = "NONE",
})

local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
local cursorline_bg = normal.bg and string.format("#%06x", normal.bg) or "#1a1b26"

-- Derive the current-line highlight from the active colourscheme so it stays visually coherent.
vim.api.nvim_set_hl(0, "CursorLine", {
  bg = darken(cursorline_bg, 0.12),
})

-- Give the current line number a little more emphasis than surrounding numbers
vim.api.nvim_set_hl(0, "CursorLineNr", {
  bold = true,
})
