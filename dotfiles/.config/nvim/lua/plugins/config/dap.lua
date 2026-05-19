return function()
  local dap = require("dap")
  local dap_python = require("dap-python")
  local dapui = require("dapui")
  local ui = require("settings.ui")

  require("nvim-dap-virtual-text").setup({})

  vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError", linehl = "", numhl = "" })
  vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
  vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
  vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticHint", linehl = "", numhl = "" })

  dapui.setup({
    floating = ui.float(),
    layouts = {
      {
        elements = {
          { id = "scopes", size = 0.45 },
          { id = "breakpoints", size = 0.15 },
          { id = "stacks", size = 0.2 },
          { id = "watches", size = 0.2 },
        },
        position = "right",
        size = 50,
      },
      {
        elements = {
          { id = "repl", size = 0.5 },
          { id = "console", size = 0.5 },
        },
        position = "bottom",
        size = 12,
      },
    },
  })

  local open_view = function()
    dapui.open()
  end

  local close_view = function()
    dapui.close()
  end

  dap.listeners.after.event_initialized["dap_view"] = open_view
  dap.listeners.before.event_terminated["dap_view"] = close_view
  dap.listeners.before.event_exited["dap_view"] = close_view

  local debugpy = vim.fn.exepath("debugpy-adapter")
  if debugpy ~= "" then
    dap.adapters.python = {
      type = "executable",
      command = debugpy,
    }

    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Current file",
        program = "${file}",
        console = "integratedTerminal",
        pythonPath = function()
          return vim.fn.exepath("python3")
        end,
      },
      {
        type = "python",
        request = "launch",
        name = "Pytest file",
        module = "pytest",
        args = { "${file}" },
        console = "integratedTerminal",
        pythonPath = function()
          return vim.fn.exepath("python3")
        end,
      },
    }

    dap_python.test_runner = "pytest"
  end

  dap.adapters.go = function(callback, _)
    callback({
      type = "server",
      host = "127.0.0.1",
      port = "${port}",
      executable = {
        command = vim.fn.exepath("dlv"),
        args = { "dap", "-l", "127.0.0.1:${port}" },
      },
    })
  end

  dap.configurations.go = {
    {
      type = "go",
      name = "Debug file",
      request = "launch",
      program = "${file}",
    },
    {
      type = "go",
      name = "Debug package",
      request = "launch",
      program = "${fileDirname}",
    },
    {
      type = "go",
      name = "Debug test file",
      request = "launch",
      mode = "test",
      program = "${file}",
    },
  }
end
