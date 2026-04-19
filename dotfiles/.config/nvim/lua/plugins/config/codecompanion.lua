return function()
  local function executable(name)
    local path = vim.fn.exepath(name)

    if path ~= "" then
      return path
    end

    return name
  end

  require("codecompanion").setup({
    adapters = {
      acp = {
        codex = function()
          return require("codecompanion.adapters").extend("codex", {
            commands = {
              default = {
                executable("codex-acp"),
              },
            },
            defaults = {
              auth_method = "chatgpt",
              model = "gpt-5-codex",
              timeout = 60000,
            },
          })
        end,
      },
      http = {
        openai_responses = function()
          return require("codecompanion.adapters").extend("openai_responses", {
            schema = {
              model = {
                default = "gpt-5-codex",
              },
            },
          })
        end,
      },
    },
    interactions = {
      chat = {
        adapter = "codex",
      },
      inline = {
        adapter = "openai_responses",
      },
      cmd = {
        adapter = "openai_responses",
      },
    },
    opts = {
      log_level = "ERROR",
    },
  })
end
