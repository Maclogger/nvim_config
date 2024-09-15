-- lua/lsp.lua
local python_servers = require("plugins.lsp.python")
local java_servers = require("plugins.lsp.java")

-- Zlúčiť tabuľky serverov
local servers = vim.tbl_extend("force", python_servers, java_servers)

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = servers,
    },
  },
}
