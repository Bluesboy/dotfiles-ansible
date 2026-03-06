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

      local yamllint_base = '{extends: default, rules: {comments: {min-spaces-from-content: 1}, truthy: {allowed-values: ["true", "false", "yes", "no"]}, document-start: disable, line-length: {max: 120}, indentation: {spaces: 2, indent-sequences: false}}}'
      local yamllint_gha  = '{extends: default, rules: {comments: {min-spaces-from-content: 1}, truthy: {allowed-values: ["true", "false", "yes", "no", "on", "off"]}, document-start: disable, line-length: {max: 120}, indentation: {spaces: 2, indent-sequences: false}}}'

      local function yamllint_args(conf)
        return { "--format", "parsable", "-d", conf, "-" }
      end

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          local path = vim.api.nvim_buf_get_name(0)
          if path:match("%.github/workflows/") then
            lint.linters.yamllint.args = yamllint_args(yamllint_gha)
          else
            lint.linters.yamllint.args = yamllint_args(yamllint_base)
          end
          lint.try_lint()
        end,
      })
    end,
  },
}
