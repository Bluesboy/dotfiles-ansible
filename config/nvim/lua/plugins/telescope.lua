return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.5",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-lua/popup.nvim",
    "nvim-telescope/telescope-media-files.nvim",
  },
  config = function()
    require("telescope").setup({
      defaults = {

        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "smart" },

        mappings = {
          i = {
            ["<C-n>"] = cycle_history_next,
            ["<C-p>"] = cycle_history_prev,

            ["<C-j>"] = move_selection_next,
            ["<C-k>"] = move_selection_previous,

            ["<C-c>"] = close,

            ["<Down>"] = move_selection_next,
            ["<Up>"] = move_selection_previous,

            ["<CR>"] = select_default,
            ["<C-x>"] = select_horizontal,
            ["<C-v>"] = select_vertical,
            ["<C-t>"] = select_tab,

            ["<C-u>"] = preview_scrolling_up,
            ["<C-d>"] = preview_scrolling_down,

            ["<PageUp>"] = results_scrolling_up,
            ["<PageDown>"] = results_scrolling_down,

            -- ["<Tab>"] = toggle_selection + move_selection_worse,
            -- ["<S-Tab>"] = toggle_selection + move_selection_better,
            -- ["<C-q>"] = send_to_qflist + open_qflist,
            -- ["<M-q>"] = send_selected_to_qflist + open_qflist,
            ["<C-l>"] = complete_tag,
            ["<C-_>"] = which_key, -- keys from pressing <C-/>
          },

          n = {
            ["<esc>"] = close,
            ["<CR>"] = select_default,
            ["<C-x>"] = select_horizontal,
            ["<C-v>"] = select_vertical,
            ["<C-t>"] = select_tab,

            -- ["<Tab>"] = toggle_selection + move_selection_worse,
            -- ["<S-Tab>"] = toggle_selection + move_selection_better,
            -- ["<C-q>"] = send_to_qflist + open_qflist,
            -- ["<M-q>"] = send_selected_to_qflist + open_qflist,

            ["j"] = move_selection_next,
            ["k"] = move_selection_previous,
            ["H"] = move_to_top,
            ["M"] = move_to_middle,
            ["L"] = move_to_bottom,

            ["<Down>"] = move_selection_next,
            ["<Up>"] = move_selection_previous,
            ["gg"] = move_to_top,
            ["G"] = move_to_bottom,

            ["<C-u>"] = preview_scrolling_up,
            ["<C-d>"] = preview_scrolling_down,

            ["<PageUp>"] = results_scrolling_up,
            ["<PageDown>"] = results_scrolling_down,

            ["?"] = which_key,
          },
        },
      },
      pickers = {
        -- Default configuration for builtin pickers goes here:
        -- picker_name = {
        --   picker_config_key = value,
        --   ...
        -- }
        -- Now the picker_config_key will be applied every time you call this
        -- builtin picker
      },
      extensions = {
        media_files = {
          filetypes = { "png", "webp", "jpg", "jpeg", "pdf" },
          find_cmd = "rg",
        },
        -- Your extension configuration goes here:
        -- extension_name = {
        --   extension_config_key = value,
        -- }
        -- please take a look at the readme of the extension you want to configure
      },
    })

    require("telescope").load_extension("media_files")
  end,
}
