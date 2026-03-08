return {
  "y3owk1n/time-machine.nvim",
  version = "*",
  cmd = {
    "TimeMachineToggle",
    "TimeMachinePurgeBuffer",
    "TimeMachinePurgeAll",
    "TimeMachineLogShow",
    "TimeMachineLogClear",
  },
  keys = {
    { "<leader>tm", "<cmd>TimeMachineToggle<cr>", desc = "Toggle [T]ime [M]achine" },
    { "<leader>tl", "<cmd>TimeMachineLogShow<cr>", desc = "Show [T]ime Machine [L]og" },
  },
  opts = {},
}
