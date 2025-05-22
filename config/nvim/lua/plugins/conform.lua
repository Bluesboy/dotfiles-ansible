return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = "",
        desc = "[F]ormat buffer",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = {
          yaml = true,
          c = true,
          cpp = true,
          go = true,
        }

        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 200,
            lsp_format = "fallback",
          }
        end
      end,
      formatters = {
        yamlfmt = {
          prepend_args = {
            "-formatter",
            "indentless_arrays=true",
            "-formatter",
            "retain_line_breaks_single=true",
            "-formatter",
            "trim_trailing_whitespace=true",
            "-formatter",
            "include_document_start=false",
            "-formatter",
            "scan_folded_as_literal=true",
          },
        },
      },
      formatters_by_ft = {
        lua = { "stylua" },
        yaml = { "yamlfmt" },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
