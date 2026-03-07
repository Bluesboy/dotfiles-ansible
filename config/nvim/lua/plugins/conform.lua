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
      format_on_save = false,
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
        ["yaml.ansible"] = { "yamlfmt" },
      },
    },
  },
}
