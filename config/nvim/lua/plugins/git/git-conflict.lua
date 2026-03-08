return {
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("git-conflict").setup({
        default_mappings = {
          ours = "o",
          theirs = "t",
          none = "0",
          both = "b",
          next = "n",
          prev = "p",
        },
      })
    end,
  },
}
