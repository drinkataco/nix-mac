return function()
  local i = require("neogen.types.template").item
  local tsdoc = require("neogen.templates.tsdoc")
  -- Insert description placeholder after the opening /** for funcs/classes with results
  table.insert(tsdoc, 7, { nil, " * $1", { type = { "func", "class" } } })

  require("neogen").setup({
    snippet_engine = "luasnip",
    languages = {
      typescript = {
        template = { annotation_convention = "tsdoc", tsdoc = tsdoc },
      },
      typescriptreact = {
        template = { annotation_convention = "tsdoc", tsdoc = tsdoc },
      },
    },
  })
end
