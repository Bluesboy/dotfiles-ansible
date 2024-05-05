return {
  "akinsho/toggleterm.nvim",
  config = function()
    require("toggleterm").setup({
      autochdir = true,
    })
  end,
}
