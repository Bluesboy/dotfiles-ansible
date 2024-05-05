return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/playground",
  },
  build = ":TSUpdate",
  config = function()
    local config = require("nvim-treesitter.configs")

    config.setup({
      ensure_installed = {
        "lua",
        "python",
        "vim",
        "vimdoc",
        "yaml",
        "go",
        "json",
        "hcl",
        "terraform",
      },

      sync_install = false,
      auto_install = true,
      ignore_install = { "" },

      highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
      },
      playground = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    })
  end,
}
