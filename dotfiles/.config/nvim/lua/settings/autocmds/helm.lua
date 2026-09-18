-- Reclassify YAML files that contain Go template syntax as `helm` so the
-- helm treesitter parser and vim-helm syntax kick in, and yamlls stays off
-- buffers it would flag as invalid. Proper Helm charts under templates/ are
-- already handled by towolf/vim-helm's own detection.
vim.filetype.add({
  pattern = {
    [".*%.ya?ml"] = function(_, bufnr)
      for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, 200, false)) do
        if line:find("{{.-}}") then
          return "helm"
        end
      end
    end,
  },
})
