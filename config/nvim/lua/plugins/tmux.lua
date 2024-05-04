return {
  "aserowy/tmux.nvim",
  config = function()
    require("tmux").setup({
      copy_sync = {
        enable = true,
      },
      navigation = {
        enable_default_keybindings = true,
      },
      resize = {
        enable_default_keybindings = true,
      },
    })
  end
}
