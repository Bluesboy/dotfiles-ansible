return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  event = { "BufReadPost", "BufNewFile" },
  build = ":TSUpdate",
  config = function()
    -- Highlighting via Neovim's built-in treesitter API
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local ft = vim.bo[args.buf].filetype
        if ft == "" then return end
        pcall(vim.treesitter.start, args.buf)
      end,
    })

    -- Treesitter-based indent for all filetypes except yaml
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function(args)
        if vim.bo[args.buf].filetype ~= "yaml" then
          pcall(function()
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end)
        end
      end,
    })

    -- Auto-install parser for current filetype if missing
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local ft = vim.bo[args.buf].filetype
        if ft == "" then return end
        local lang = vim.treesitter.language.get_lang(ft)
        if lang and require("nvim-treesitter.parsers")[lang] then
          pcall(require("nvim-treesitter.install").install, { lang })
        end
      end,
    })

    -- Ensure core parsers are installed
    require("nvim-treesitter.install").install({
      "lua",
      "luadoc",
      "diff",
      "python",
      "vim",
      "vimdoc",
      "markdown",
      "markdown_inline",
      "bash",
      "yaml",
      "go",
      "json",
      "hcl",
      "terraform",
      "dockerfile",
    })
  end,
}
