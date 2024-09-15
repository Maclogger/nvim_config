-- lua/plugins/mason.lua
return {
  "williamboman/mason.nvim",
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, {
      "jdtls",
    })
  end,
}
