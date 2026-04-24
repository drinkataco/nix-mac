local M = {}

---Convert markdown heading text into the anchor format used by the table of
---contents links in `docs/nvim.md`.
---@param text string
---@return string
local function markdown_anchor(text)
  local anchor = text:lower()
  anchor = anchor:gsub("`", "")
  anchor = anchor:gsub("[%[%]%(%)%{%}!?,.:;/\\\"']", "")
  anchor = anchor:gsub("&", "")
  anchor = anchor:gsub("%s+", "-")
  anchor = anchor:gsub("%-+", "-")
  anchor = anchor:gsub("^%-", "")
  anchor = anchor:gsub("%-$", "")
  return anchor
end

---Jump from the local markdown anchor link under the cursor to the matching
---heading in the provided buffer.
---@param buf integer
---@return boolean
function M.jump_anchor(buf)
  local line = vim.api.nvim_get_current_line()
  local anchor = line:match("%[[^%]]-%]%((#.-)%)")
  if anchor == nil then
    return false
  end

  anchor = anchor:gsub("^#", "")

  for lnum, heading in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    local text = heading:match("^#+%s+(.*)$")
    if text ~= nil and markdown_anchor(text) == anchor then
      vim.api.nvim_win_set_cursor(0, { lnum, 0 })
      vim.cmd("normal! zz")
      return true
    end
  end

  vim.notify("No heading found for #" .. anchor, vim.log.levels.WARN)
  return false
end

---Open `docs/nvim.md` in a centered, read-only floating window that still uses
---the real buffer so search, syntax, and local TOC jumps behave normally.
---@return integer|nil
local function find_open_window()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    local buf = vim.api.nvim_win_get_buf(win)
    if config.relative ~= "" and vim.b[buf].nvim_docs_float == true then
      return win
    end
  end
end

---Open or close the floating `docs/nvim.md` reference window.
function M.toggle()
  local existing = find_open_window()
  if existing ~= nil and vim.api.nvim_win_is_valid(existing) then
    vim.api.nvim_win_close(existing, true)
    return
  end

  local path = vim.fn.expand("~/projects/nix-mac/docs/nvim.md")
  if vim.fn.filereadable(path) == 0 then
    vim.notify("Missing docs file: " .. path, vim.log.levels.ERROR)
    return
  end

  local buf = vim.fn.bufadd(path)
  vim.fn.bufload(buf)

  local width = math.min(math.floor(vim.o.columns * 0.8), 120)
  local height = math.min(math.floor(vim.o.lines * 0.8), 40)
  local row = math.floor((vim.o.lines - height) / 2) - 1
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, require("settings.ui").float({
    relative = "editor",
    width = width,
    height = height,
    row = math.max(row, 0),
    col = math.max(col, 0),
    style = "minimal",
  }))

  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].buflisted = false
  vim.bo[buf].modifiable = false
  vim.bo[buf].readonly = true
  vim.b[buf].nvim_docs_float = true
  vim.wo[win].wrap = true
  vim.wo[win].linebreak = true
  vim.wo[win].cursorline = false

  vim.keymap.set("n", "<CR>", function()
    M.jump_anchor(buf)
  end, { buffer = buf, silent = true, desc = "Jump to heading" })
end

M.open = M.toggle

return M
