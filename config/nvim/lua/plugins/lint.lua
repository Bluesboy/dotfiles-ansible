return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        markdown = { "markdownlint" },
        yaml = { "yamllint" },
      }

      lint.linters.yamllint.args = {
        "--format",
        "parsable",
        "-d",
        '{extends: default, rules: {comments: {min-spaces-from-content: 1}, truthy: {allowed-values: ["true", "false", "yes", "no"]}, document-start: {present: false}, line-length: {max: 120}, indentation: {spaces: 2, indent-sequences: false}}}',
        "-",
      }

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
