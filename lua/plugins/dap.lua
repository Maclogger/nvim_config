return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      -- Nastavenie nvim-dap
      local dap = require("dap")
      local dapui = require("dapui")

      -- Nastavenie nvim-dap-ui
      dapui.setup()
      require("nvim-dap-virtual-text").setup({})
      require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")

      -- Automatické otvorenie/zatvorenie dap-ui
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
