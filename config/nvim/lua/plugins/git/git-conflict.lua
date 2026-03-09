return {
  {
    "akinsho/git-conflict.nvim",
    event = { "BufReadPost", "BufNewFile" },
    version = "*",
    opts = {
      default_mappings = {
        ours = "o",
        theirs = "t",
        none = "0",
        both = "b",
        next = "n",
        prev = "p",
      },
    },
  },
}
