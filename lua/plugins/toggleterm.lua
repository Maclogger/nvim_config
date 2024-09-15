return {
  "akinsho/toggleterm.nvim",
  config = function()
    require("toggleterm").setup({
      direction = "vertical", -- alebo 'horizontal', alebo 'float'
      size = 80, -- šírka bočného okna pri 'vertical'
    })
  end,
}
