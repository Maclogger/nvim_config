return {
  "danymat/neogen",
  config = function()
    require("neogen").setup({
      enabled = true,
      languages = {
        php = {
          template = {
            annotation_convention = "phpdoc",
          },
        },
      },
    })
  end,
  dependencies = "nvim-treesitter/nvim-treesitter",
}
