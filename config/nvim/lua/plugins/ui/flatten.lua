return {
  {
    "willothy/flatten.nvim",
    config = function()
      require("flatten").setup({
        integrations = {
          wezterm = false,
        },
      })
    end,
  },
}
