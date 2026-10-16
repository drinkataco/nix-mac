local api = vim.api

-- helm-ls.nvim's ftdetect only recognises values*.yaml by basename, so charts
-- that split values across a directory tree (e.g. values/core/foo.yaml) fall
-- through to plain yaml and miss helm_ls/yamlls's value-schema support.
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

    -- Chart.yaml keeps its own schema; templates/** is already "helm".
    if path:match("/Chart%.ya?ml$") or path:match("/templates/") then
      return
    end

    if chart_root(path) then
      vim.bo[args.buf].filetype = "yaml.helm-values"
    end
  end,
})
