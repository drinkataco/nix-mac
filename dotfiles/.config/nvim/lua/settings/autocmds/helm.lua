vim.filetype.add({ extension = { tpl = "helm" } })

local helm = vim.api.nvim_create_augroup("settings_helm_filetype", { clear = true })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = helm,
  pattern = { "*.yaml", "*.yml" },
  callback = function(ev)
    local path = vim.api.nvim_buf_get_name(ev.buf)
    if vim.fs.find("Chart.yaml", { path = vim.fs.dirname(path), upward = true })[1] then
      vim.bo[ev.buf].filetype = "helm"
    end
  end,
})
