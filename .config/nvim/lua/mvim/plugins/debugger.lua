local M = {
  "mfussenegger/nvim-dap",
  -- stylua: ignore
  keys = {
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
    { "<leader>dr", function() require("dap").restart() end, desc = "Restart" },
    { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
    { "<leader>do", function() require("dap").step_out() end, desc = "Step out" },
    { "<leader>dO", function() require("dap").step_over() end, desc = "Step over" },
  },
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      dependencies = { "nvim-neotest/nvim-nio" },
      -- stylua: ignore
      keys = {
        { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
      },
      opts = {
        icons = {
          expanded = "",
          collapsed = "",
          current_frame = "",
        },
        layouts = {
          {
            elements = {
              "scopes",
              "stacks",
              "watches",
              "breakpoints",
            },
            size = 0.3,
            position = "right",
          },
          {
            elements = { "repl" },
            size = 0.24,
            position = "bottom",
          },
        },
        floating = { border = Mo.C.border },
      },
      config = function(_, opts)
        -- setup listener
        local dap, dapui = require("dap"), require("dapui")

        dapui.setup(opts)

        dap.listeners.after.event_initialized["dapui_config"] = function()
          local breakpoints = require("dap.breakpoints").get()
          local args = vim.tbl_isempty(breakpoints) and {} or { layout = 2 }
          dapui.open(args)
        end
        dap.listeners.before.event_stopped["dapui_config"] = function(_, body)
          if body.reason == "breakpoint" then
            dapui.open({})
          end
        end
        -- dap.listeners.before.event_terminated["dapui_config"] = function()
        --   dapui.close({})
        -- end
        -- dap.listeners.before.event_exited["dapui_config"] = function()
        --   dapui.close({})
        -- end
      end,
    },
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = { highlight_new_as_changed = true },
    },
  },
  init = function()
    vim.fn.sign_define(
      "DapStopped",
      { text = "󰋇 ", texthl = "DapStopped", numhl = "DapStopped" }
    )
    vim.fn.sign_define(
      "DapBreakpoint",
      { text = "󰄛 ", texthl = "DapBreakpoint", numhl = "DapBreakpoint" }
    )
  end,
  config = function()
    -- load launch.json file
    if vim.fn.filereadable(".vscode/launch.json") then
      require("dap.ext.vscode").load_launchjs()
    end

    local dap = require("dap")
    -- setup adapter
    dap.adapters.python = {
      type = "executable",
      command = "python",
      args = { "-m", "debugpy.adapter" },
      options = {
        source_filetype = "python",
      },
    }

    dap.adapters.go = {
      type = "server",
      port = "${port}",
      executable = {
        command = "dlv",
        args = { "dap", "-l", "127.0.0.1:" .. "${port}" },
      },
      options = {
        initialize_timeout_sec = 10,
      },
    }

    -- https://github.com/rcarriga/nvim-dap-ui/issues/248
    Mo.U.augroup("DapReplOptions", {
      event = "BufWinEnter",
      pattern = { "\\[dap-repl\\]", "DAP *" },
      command = vim.schedule_wrap(function(args)
        local win = vim.fn.bufwinid(args.buf)
        vim.api.nvim_set_option_value("wrap", true, { win = win })
      end),
    })
  end,
}

return M
