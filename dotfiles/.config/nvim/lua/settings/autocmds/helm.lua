-- Detect Helm chart templates by walking up to a Chart.yaml, rather than
-- scanning file contents. More precise than the Go-template heuristic and
-- avoids false positives on non-Helm YAML that happens to use {{ }}.
vim.filetype.add({
  extension = { tpl = "helm" },
  pattern = {
    [".*%.ya?ml"] = {
      function(path, _bufnr)
        if vim.fs.find("Chart.yaml", { path = vim.fs.dirname(path), upward = true })[1] then
          return "helm"
        end
      end,
      { priority = 10 },
    },
  },
})
