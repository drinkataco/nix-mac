local api = vim.api

-- helm-ls.nvim's ftdetect only recognises values*.yaml by basename and
-- templates/** by directory, both of which it already types correctly
-- (yaml.helm-values / helm). Everything else under a chart is Go template
-- source too (e.g. values/core/foo.yaml rendered via `tpl`), so default it
-- to "helm" as well -- its injections.scm already gives plain yaml the
-- same highlighting for the non-{{ }} parts, so nothing is lost.
local function chart_root(path)
  local dir = vim.fn.fnamemodify(path, ":p:h")
  for _ = 1, 50 do
    if vim.fn.filereadable(dir .. "/Chart.yaml") == 1 then
      return dir
    end
    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir then
      return nil
    end
    dir = parent
  end
  return nil
end

local group = api.nvim_create_augroup("settings_helm_values_filetype", { clear = true })
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = group,
  pattern = { "*.yaml", "*.yml" },
  callback = function(args)
    local path = api.nvim_buf_get_name(args.buf)

    -- This autocmd can fire before the builtin extension-based default and
    -- helm-ls.nvim's own ftdetect have run, so vim.bo.filetype isn't a
    -- reliable signal yet. Ask the matcher directly instead: anything more
    -- specific than the generic "yaml" fallback (yaml.helm-values, helm,
    -- ...) is already correct and left alone.
    local matched = vim.filetype.match({ filename = path })
    if matched and matched ~= "yaml" then
      return
    end

    if path:match("/Chart%.ya?ml$") then
      return
    end

    if chart_root(path) then
      vim.bo[args.buf].filetype = "helm"
    end
  end,
})
