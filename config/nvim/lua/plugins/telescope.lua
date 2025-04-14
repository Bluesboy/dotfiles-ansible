return {
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    },
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
        defaults = {

          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "smart" },
          --
          --   mappings = {
          --     i = {
          --       ["<C-n>"] = cycle_history_next,
          --       ["<C-p>"] = cycle_history_prev,
          --
          --       ["<C-j>"] = move_selection_next,
          --       ["<C-k>"] = move_selection_previous,
          --
          --       ["<C-c>"] = close,
          --
          --       ["<Down>"] = move_selection_next,
          --       ["<Up>"] = move_selection_previous,
          --
          --       ["<CR>"] = select_default,
          --       ["<C-x>"] = select_horizontal,
          --       ["<C-v>"] = select_vertical,
          --       ["<C-t>"] = select_tab,
          --
          --       ["<C-u>"] = preview_scrolling_up,
          --       ["<C-d>"] = preview_scrolling_down,
          --
          --       ["<PageUp>"] = results_scrolling_up,
          --       ["<PageDown>"] = results_scrolling_down,
          --
          --       -- ["<Tab>"] = toggle_selection + move_selection_worse,
          --       -- ["<S-Tab>"] = toggle_selection + move_selection_better,
          --       -- ["<C-q>"] = send_to_qflist + open_qflist,
          --       -- ["<M-q>"] = send_selected_to_qflist + open_qflist,
          --       ["<C-l>"] = complete_tag,
          --       ["<C-_>"] = which_key, -- keys from pressing <C-/>
          --     },
          --
          --     n = {
          --       ["<esc>"] = close,
          --       ["<CR>"] = select_default,
          --       ["<C-x>"] = select_horizontal,
          --       ["<C-v>"] = select_vertical,
          --       ["<C-t>"] = select_tab,
          --
          --       -- ["<Tab>"] = toggle_selection + move_selection_worse,
          --       -- ["<S-Tab>"] = toggle_selection + move_selection_better,
          --       -- ["<C-q>"] = send_to_qflist + open_qflist,
          --       -- ["<M-q>"] = send_selected_to_qflist + open_qflist,
          --
          --       ["j"] = move_selection_next,
          --       ["k"] = move_selection_previous,
          --       ["H"] = move_to_top,
          --       ["M"] = move_to_middle,
          --       ["L"] = move_to_bottom,
          --
          --       ["<Down>"] = move_selection_next,
          --       ["<Up>"] = move_selection_previous,
          --       ["gg"] = move_to_top,
          --       ["G"] = move_to_bottom,
          --
          --       ["<C-u>"] = preview_scrolling_up,
          --       ["<C-d>"] = preview_scrolling_down,
          --
          --       ["<PageUp>"] = results_scrolling_up,
          --       ["<PageDown>"] = results_scrolling_down,
          --
          --       ["?"] = which_key,
          --     },
          --   },
          -- },
        },
        -- pickers = {
        --   -- Default configuration for builtin pickers goes here:
        --   -- picker_name = {
        --   --   picker_config_key = value,
        --   --   ...
        --   -- }
        --   -- Now the picker_config_key will be applied every time you call this
        --   -- builtin picker
        -- },
      })

      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")

      -- See `:help telescope.builtin`
      local builtin = require("telescope.builtin")
      local function map(mode, lhs, rhs, opts)
        local options = { noremap = true, silent = true }
        if opts then
          options = vim.tbl_extend("force", options, opts)
        end
        vim.keymap.set(mode, lhs, rhs, options)
      end

      map("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
      map("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
      map("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
      map("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
      map("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
      map("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
      map("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
      map("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
      map("n", "<leader>so.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      map("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

      -- Slightly advanced example of overriding default behavior and theme
      map("n", "<leader>/", function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = "[/] Fuzzily search in current buffer" })
      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      map("n", "<leader>s/", function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        })
      end, { desc = "[S]earch [/] in Open Files" })

      -- Shortcut for searching your Neovim configuration files
      map("n", "<leader>sn", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "[S]earch [N]eovim files" })
    end,
  },
  {
    "sopa0/telescope-makefile",
  },
}
