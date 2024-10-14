return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  main = "nvim-treesitter.configs",
  opts = {
    ensure_installed = {
      "lua",
      "luadoc",
      "diff",
      "python",
      "vim",
      "vimdoc",
      "markdown",
      "bash",
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
  },
}
