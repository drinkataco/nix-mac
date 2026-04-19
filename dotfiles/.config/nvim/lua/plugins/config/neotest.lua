return function()
  require("lazy").load({ plugins = { "nvim-nio" } })

  require("neotest").setup({
    floating = {
      border = "rounded",
    },
    adapters = {
      require("neotest-golang"),
      require("neotest-vitest")({
        filter_dir = function(name)
          return name ~= "node_modules"
        end,
      }),
      require("neotest-jest"),
      require("neotest-python"),
      require("neotest-rust"),
    },
  })
end
