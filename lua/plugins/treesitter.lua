return {
  "nvim-treesitter/nvim-treesitter",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "dart",
        "lua",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "html",
        "css",
        "scss",
        "yaml",
        "bash",
      },
      sync_install = false, -- Whether to install parsers synchronously (only used for `ensure_installed`)
      ignore_install = { "javascript" }, -- List of parsers to ignore installing
      auto_install = true,
      highlight = {
        enable = true, -- false will disable the whole extension
      },
      indent = {
        enable = true,
      },
      modules = {},
    })
  end,
}
