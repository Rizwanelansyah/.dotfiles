return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-telescope/telescope-dap.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local daptext = require("nvim-dap-virtual-text")
      local tele = require("telescope")
      local icons = V.opt("icons")

      vim.fn.sign_define(
        "DapBreakpoint",
        { text = icons.breakpoint, texthl = "debugBreakpoint", linehl = "", numhl = "" }
      )
      vim.fn.sign_define("DapBreakpointCondition", {
        text = icons.breakpoint_condition,
        texthl = "debugBreakpoint",
        linehl = "",
        numhl = "",
      })
      vim.fn.sign_define("DapStopped", { text = icons.stop, texthl = "debugPC", linehl = "", numhl = "" })

      dap.defaults.fallback.force_external_terminal = true
      daptext.setup(V.opt("dap"))
      dapui.setup(V.opt("dap.ui"))
      tele.load_extension("dap")

      local adapaters = V.opt("dap.adpaters")
      for key, value in pairs(adapaters) do
        dap.adapters[key] = value
      end

      local configs = V.opt("dap.configs")
      for key, value in pairs(configs) do
        dap.configurations[key] = value
      end

      vim.keymap.set("n", "<leader>dd", function()
        dap.toggle_breakpoint()
      end, { desc = "DAP :: Toggle Breakpoint" })

      vim.keymap.set("n", "<leader>dK", function()
        require("dap.ui.widgets").hover()
      end, { desc = "DAP :: Hover" })

      vim.keymap.set("n", "<leader>dC", function()
        dap.clear_breakpoints()
      end, { desc = "DAP :: Clear Breakpoints" })

      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "DAP :: Continue" })
      vim.keymap.set("n", "<leader>du", dapui.open, { desc = "DAP :: Open UI" })
      vim.keymap.set("n", "<leader>du", dapui.close, { desc = "DAP :: Close UI" })

      vim.keymap.set("n", "<leader>ds", function()
        dap.continue()
        dapui.open()
      end, { desc = "DAP :: Start" })

      vim.keymap.set("n", "<leader>do", function()
        dap.step_over()
      end, { desc = "DAP :: Step Over" })

      vim.keymap.set("n", "<leader>di", function()
        dap.step_back()
      end, { desc = "DAP :: Step Into" })

      vim.keymap.set("n", "<leader>dO", function()
        dap.step_back()
      end, { desc = "DAP :: Step Out" })

      vim.keymap.set("n", "<leader>dr", function()
        dap.repl.open()
      end, { desc = "DAP :: Repl" })

      vim.keymap.set("n", "<leader>dl", function()
        dap.run_last()
      end, { desc = "DAP :: Run Last" })

      vim.keymap.set("n", "<leader>dT", function()
        dap.terminate()
        dapui.close()
        vim.cmd.sleep("50ms")
        dap.repl.close()
      end, { desc = "DAP :: Terminate" })

      vim.keymap.set("n", "<leader>dR", function()
        dap.terminate()
        vim.cmd.sleep("50ms")
        dap.repl.close()
        dap.continue()
      end, { desc = "DAP :: Restart" })

      vim.keymap.set("n", "<leader>fd", "", { desc = "Telescope :: Dap" })

      vim.keymap.set("n", "<leader>fdc", function()
        dap.terminate()
        vim.cmd.sleep("50ms")
        dap.repl.close()
        dap.continue()
      end, { desc = "Telescope :: DAP" })
    end,
  },
}
