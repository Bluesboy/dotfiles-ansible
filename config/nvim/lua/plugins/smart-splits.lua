return {
  {
    "mrjones2014/smart-splits.nvim",
    config = function()
      require("smart-splits").setup({
        -- Ignored buffer types (only while resizing)
        ignored_buftypes = {
          "nofile",
          "quickfix",
          "prompt",
        },
        ignored_filetypes = { "NeoTree" },
        default_amount = 1,
        at_edge = "wrap",
        float_win_behavior = "previous",
        move_cursor_same_row = false,
        cursor_follows_swapped_bufs = false,
        ignored_events = {
          "BufEnter",
          "WinEnter",
        },
        multiplexer_integration = 'tmux',
        disable_multiplexer_nav_when_zoomed = false,
        kitty_password = nil,
        zellij_move_focus_or_tab = false,
        log_level = "info",
      })

      local function map(mode, lhs, rhs, opts)
        local options = { noremap = true, silent = true }
        if opts then
          options = vim.tbl_extend("force", options, opts)
        end
        vim.keymap.set(mode, lhs, rhs, options)
      end
      --

      local ss = require("smart-splits")

      map("n", "<A-h>", ss.resize_left, { desc = "Resize pane left" })
      map("n", "<A-j>", ss.resize_down, { desc = "Resize pane down" })
      map("n", "<A-k>", ss.resize_up, { desc = "Resize pane up" })
      map("n", "<A-l>", ss.resize_right, { desc = "Resize pane right" })

      -- moving between splits
      map("n", "<C-h>", ss.move_cursor_left, { desc = "Move Cursor to the Left Pane" })
      map("n", "<C-j>", ss.move_cursor_down, { desc = "Move Cursor to the Bottom Pane" })
      map("n", "<C-k>", ss.move_cursor_up, { desc = "Move Cursor to the Upper Pane" })
      map("n", "<C-l>", ss.move_cursor_right, { desc = "Move Cursor to the Right Pane" })
      map("n", "<C-\\>", ss.move_cursor_previous, { desc = "Move Cursor to Preview Pane" })

      -- swapping buffers between windows
      map("n", "<leader>sh", ss.swap_buf_left, { desc = "Swap with Left Pane" })
      map("n", "<leader>sj", ss.swap_buf_down, { desc = "Swap with Bottom Pane" })
      map("n", "<leader>sk", ss.swap_buf_up, { desc = "Swap with Upper Pane" })
      map("n", "<leader>sl", ss.swap_buf_right, { desc = "Swap with Right Pane" })
    end,
  },
}
