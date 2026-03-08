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
    { "<leader>tm", "<cmd>TimeMachineToggle<cr>", desc = "Toggle Time Machine" },
  },
  opts = {},
}
