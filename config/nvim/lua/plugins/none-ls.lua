return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics
    require("null-ls").setup({
      sources = {
        formatting.prettier.with({ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } }),
        formatting.black.with({ extra_args = { "--fast" } }),
        formatting.stylua,
        formatting.terraform_fmt,
        -- diagnostics.flake8,
        diagnostics.terraform_validate,
        null_ls.builtins.completion.spell,
      },
    })
  end,
}
