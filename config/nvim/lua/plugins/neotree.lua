return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    "s1n7ax/nvim-window-picker",
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  cmd = "Neotree",
  keys = {
    { "\\", ":Neotree toggle<CR>", desc = "Toggle NeoTree", silent = true },
  },
  opts = {
    window = {
      mappings = {
        ["<cr>"] = "open_drop",
        ["l"] = "open",
        ["h"] = "navigate_up",
        ["<bs>"] = "toggle_hidden",
        ["\\"] = "close_window",
        ["<tab>"] = "next_source",
        ["<S-tab>"] = "prev_source",
        ["right"] = "focus_preview",
        ["up"] = "scroll_preview",
        ["down"] = "scroll_preview",
      },
    },
  },
}
