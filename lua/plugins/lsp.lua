local python_servers = require("plugins.lsp.python")
local java_servers = require("plugins.lsp.java")

-- Zlúčiť tabuľky serverov
local servers = vim.tbl_extend("force", python_servers, java_servers)

return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    servers = servers,
    -- config = function()
    --   local lsp_config = require("lspconfig")
    --
    --   require("mason").setup()
    --   require("mason-lspconfig").setup({
    --     ensure_installed = {
    --       "astro",
    --       "tailwindcss",
    --       "lua_ls",
    --       -- "dartls", -- Odstránené
    --     },
    --   })
    --
    --   local capabilities = require("cmp_nvim_lsp").default_capabilities()
    --
    --   vim.diagnostic.config({
    --     virtual_text = true,
    --     signs = false,
    --   })
    --
    --   local dartExcludedFolders = {
    --
    --     vim.fn.expand("$HOME/AppData/Local/Pub/Cache"),
    --     vim.fn.expand("$HOME/.pub-cache"),
    --     vim.fn.expand("/opt/homebrew/"),
    --     vim.fn.expand("/snap/bin/flutter"),
    --   }
    --
    --   -- Manuálna konfigurácia `dartls`
    --   lsp_config["dartls"].setup({
    --     capabilities = capabilities,
    --     cmd = {
    --       "/snap/bin/dart",
    --       "language-server",
    --       "--protocol=lsp",
    --     },
    --   })
    --
    --   -- Nastavenie ostatných LSP serverov
    --   lsp_config.astro.setup({
    --     capabilities = capabilities,
    --   })
    --
    --   lsp_config.tailwindcss.setup({
    --     capabilities = capabilities,
    --   })
    --
    --   lsp_config.tsserver.setup({
    --     capabilities = capabilities,
    --   })
    --
    --   lsp_config.lua_ls.setup({
    --     capabilities = capabilities,
    --     settings = {
    --       Lua = {
    --         diagnostics = {
    --           globals = { "vim" },
    --         },
    --       },
    --     },
    --   })
    --
    --   -- Tooltip pre LSP
    --   require("fidget").setup({})
    -- end,
    -- dependencies = {
    --   "hrsh7th/cmp-nvim-lsp",
    --   { "j-hui/fidget.nvim", tag = "legacy" },
    --   -- Odstránenie `dart-tools.nvim`
    -- },
  },
}
