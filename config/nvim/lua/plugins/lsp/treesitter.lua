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
      "dockerfile",
    },

    sync_install = false,
    auto_install = true,

    highlight = {
      enable = true,
    },
    playground = {
      enable = true,
    },
    indent = {
      enable = true,
      disable = { "yaml" },
    },
  },
}
