local M = {}

M.border = "rounded"

-- Standard float options used across diagnostics, completion, and plugin popups
-- so bordered windows look consistent without repeating the same literals.
function M.float(opts)
  return vim.tbl_extend("force", {
    border = M.border,
  }, opts or {})
end

function M.diagnostic_float(opts)
  return M.float(vim.tbl_extend("force", {
    focusable = false,
    scope = "cursor",
  }, opts or {}))
end

function M.cmp_window(cmp, opts)
  return cmp.config.window.bordered(M.float(opts))
end

return M
