return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {},
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      background_colour = "#000000",
      fps = 60,
      render = "wrapped-compact",
      stages = "fade",
      timeout = 3000,
      max_width = 80,
      icons = {
        ERROR = "",
        WARN  = "",
        INFO  = "󰋼",
        DEBUG = "",
        TRACE = "✎",
      },
    },
  }
}
