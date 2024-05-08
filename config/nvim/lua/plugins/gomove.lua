return {
  "booperlv/nvim-gomove",
  config = function ()
    require("gomove").setup {
      map_defaults = true
    }
  end
}
