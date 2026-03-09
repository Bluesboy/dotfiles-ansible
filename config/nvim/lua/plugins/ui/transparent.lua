return {
  {
    "xiyaowong/transparent.nvim",
    event = "VeryLazy",
    config = function()
      require("transparent").clear_prefix("NeoTree")
      require("transparent").clear_prefix("BufferLine")
    end,
  },
}
