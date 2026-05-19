return function()
  local dap = require("dap")
  local dap_python = require("dap-python")
  local dapui = require("dapui")
  local ui = require("settings.ui")

  require("nvim-dap-virtual-text").setup({})

  local function has_adapter(config)
    return config.type and dap.adapters[config.type] ~= nil
  end

  local function prune_configs(configs)
    return vim.tbl_filter(has_adapter, configs or {})
  end

  local function prune_missing_adapters(filetype)
    local configs = dap.configurations[filetype]
    if not configs then
      return
    end

    dap.configurations[filetype] = prune_configs(configs)
  end

  local dap_continue = dap.continue
  local launch_json_provider = dap.providers.configs["dap.launch.json"]
  -- Project-local launch configs can reference adapters we do not install
  -- here, such as node-terminal. Drop those entries before prompting so the
  -- picker only shows runnable configurations.
  dap.providers.configs["dap.launch.json"] = function(bufnr)
    return prune_configs(launch_json_provider(bufnr))
  end

  dap.continue = function(...)
    prune_missing_adapters(vim.bo.filetype)
    return dap_continue(...)
  end

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

  local js_debug_server =
    vim.fn.glob("/run/current-system/sw/share/vscode/extensions/*js-debug*/src/dapDebugServer.js", true)
  if js_debug_server ~= "" and vim.fn.exepath("node") ~= "" then
    local js_adapters = {
      "pwa-node",
      "pwa-chrome",
      "pwa-msedge",
      "node-terminal",
      "pwa-extensionHost",
    }

    for _, adapter in ipairs(js_adapters) do
      dap.adapters[adapter] = {
        type = "server",
        host = "127.0.0.1",
        port = "${port}",
        executable = {
          command = "node",
          args = { js_debug_server, "${port}" },
        },
      }
    end

    local js_configurations = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Current file",
        program = "${file}",
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
        sourceMaps = true,
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach process",
        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
        sourceMaps = true,
      },
    }

    for _, filetype in ipairs({ "javascript", "javascriptreact", "typescript", "typescriptreact" }) do
      dap.configurations[filetype] = js_configurations
    end
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
