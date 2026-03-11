return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  event = "VeryLazy",
  opts = {
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = { { "filename", path = 3 } },
      lualine_x = { "encoding", "fileformat", "filetype", "lsp_status" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    extensions = {
      "lazy",
      "neo-tree",
      "trouble",
    },
  },
}
