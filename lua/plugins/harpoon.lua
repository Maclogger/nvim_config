return {
  {
    "ThePrimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon").setup({
        save_on_toggle = true,
        save_on_change = true,
      })
    end,
  },
}
