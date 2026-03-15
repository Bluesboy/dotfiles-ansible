return {
  {
    "folke/trouble.nvim",
    event = "LspAttach",
    opts = {
      focus = true,
      modes = {
        symbols = {
          focus = true,
          win = { size = 50 },
        },
      },
    },
    cmd = "Trouble",
    keys = {
      {
        "<leader>cx",
        function()
          require("trouble").toggle("diagnostics")
        end,
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>cX",
        function()
          require("trouble").toggle({ mode = "diagnostics", filter = { buf = 0 } })
        end,
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        function()
          require("trouble").toggle("symbols")
        end,
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        function()
          require("trouble").toggle({ mode = "lsp", focus = true, win = { position = "right", size = 50 } })
        end,
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>cQ",
        function()
          require("trouble").toggle("loclist")
        end,
        desc = "Location List (Trouble)",
      },
      {
        "<leader>cq",
        function()
          require("trouble").toggle("qflist")
        end,
        desc = "Quickfix List (Trouble)",
      },
    },
  },
}
