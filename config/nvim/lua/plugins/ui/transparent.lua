return {
  {
    "xiyaowong/transparent.nvim",
    config = function()
      require("transparent").clear_prefix("NeoTree")
      require("transparent").clear_prefix("BufferLine")
    end,
  },
}
