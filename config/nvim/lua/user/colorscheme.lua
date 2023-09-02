require("github-theme").setup({
  options = {
    styles = {
      functions = 'italic'
    },
    darken = {
      floats = false,
      sidebars = {
        enabled = true,
        list = {
          "qf",
          "vista_kind",
          "terminal",
          "packer"
        },
      },
    },
  },
  palettes = {},
  specs = {},
  groups = {},
})

vim.cmd.colorscheme('github_dark')
