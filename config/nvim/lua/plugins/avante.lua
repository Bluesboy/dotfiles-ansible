return {
  "yetone/avante.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "echasnovski/mini.pick", -- for file_selector provider mini.pick
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "ibhagwan/fzf-lua", -- for file_selector provider fzf
    "folke/snacks.nvim", -- for input provider snacks
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
  version = false, -- Never set this value to "*"! Never!
  event = "VeryLazy",
  opts = {
    provider = "china",
    input = {
      provider = "snacks",
      provider_opts = {
        -- Additional snacks.input options
        title = "Avante Input",
        icon = " ",
      },
    },
    providers = {
      deepseek = {
        __inherited_from = "openai",
        api_key_name = "DEEPSEEK_API_KEY",
        endpoint = "https://api.deepseek.com",
        model = "deepseek-coder",
      },
      china = {
        __inherited_from = "claude",
        endpoint = "https://hubai.loe.gg",
        -- model = "claude-3-5-haiku-latest",
        -- ['claude-3-7-sonnet-20250219',
        -- 'claude-3-7-sonnet-latest',
        -- 'claude-3-5-haiku-latest',
        -- 'claude-3-5-haiku-20241022',
        -- 'claude-3-5-sonnet-latest',
        -- 'claude-3-5-sonnet-20240620',
        -- 'anthropic-3-7-sonnet-latest-cursor',
        -- 'claude-3-haiku-20240307']
        model = "claude-3-haiku-20240307",
        -- model = "claude-3-7-sonnet-20250219",
      },
    },
  },
}
