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
local terminal_bg = "#1d1f21"
local normal_fg = normal.fg and string.format("#%06x", normal.fg) or "#c0caf5"
local comment = vim.api.nvim_get_hl(0, { name = "Comment", link = false })
local comment_fg = comment.fg and string.format("#%06x", comment.fg) or normal_fg

-- Derive the current-line highlight from the active colourscheme so it stays visually coherent.
vim.api.nvim_set_hl(0, "CursorLine", {
  bg = darken(cursorline_bg, 0.12),
})

-- Give the current line number a little more emphasis than surrounding numbers
vim.api.nvim_set_hl(0, "CursorLineNr", {
  bold = true,
})

vim.api.nvim_set_hl(0, "BufferLineFill", {
  bg = terminal_bg,
})

vim.api.nvim_set_hl(0, "BufferLineBackground", {
  fg = comment_fg,
  bg = terminal_bg,
})

vim.api.nvim_set_hl(0, "BufferLineBufferVisible", {
  fg = comment_fg,
  bg = terminal_bg,
})

vim.api.nvim_set_hl(0, "BufferLineTab", {
  fg = comment_fg,
  bg = terminal_bg,
})

vim.api.nvim_set_hl(0, "BufferLineTabSelected", {
  fg = normal_fg,
  bg = terminal_bg,
  bold = true,
})

vim.api.nvim_set_hl(0, "BufferLineSeparator", {
  fg = terminal_bg,
  bg = terminal_bg,
})

vim.api.nvim_set_hl(0, "BufferLineSeparatorVisible", {
  fg = terminal_bg,
  bg = terminal_bg,
})

vim.api.nvim_set_hl(0, "BufferLineSeparatorSelected", {
  fg = terminal_bg,
  bg = terminal_bg,
})

local function copy_current_file_path()
  local path = vim.fn.expand("%:p")
  if path == "" then
    vim.notify("Current buffer has no file path", vim.log.levels.WARN)
    return
  end

  vim.fn.setreg("+", path)
  vim.notify(path)
end

-- Trim the built-in right-click popup menu a little; the help entry is useful
-- once, but noisy as a permanent action in normal editing.
vim.api.nvim_create_user_command("CopyCurrentFilePath", copy_current_file_path, {})
vim.cmd([[anoremenu PopUp.Copy\ file\ path <Cmd>CopyCurrentFilePath<CR>]])
vim.cmd([[silent! aunmenu PopUp.-2-]])
vim.cmd([[silent! aunmenu PopUp.How-to\ disable\ mouse]])
