return {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "saghen/blink.cmp",
      "b0o/schemastore.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      "towolf/vim-helm",
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

          -- Find references for the word under your cursor.
          map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "v", "x" })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          -- map("K", vim.lsp.buf.hover, "Show help")
          map("gk", vim.lsp.buf.signature_help, "Show signature help")

          -- map("<leader>wa", vim.lsp.buf.add_workspace_folder)
          -- map("<leader>wr", vim.lsp.buf.remove_workspace_folder)
          -- map("<leader>wl", function()
          --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          -- end)
          --
          -- map("<leader>D", vim.lsp.buf.type_definition)
          --
          map("gn", function()
            vim.diagnostic.jump({ count = 1, float = true })
          end, "[G]oto [N]ext diagnostic")
          map("gp", function()
            vim.diagnostic.jump({ count = -1, float = true })
          end, "[G]oto [P]revious diagnostic")

          map("<leader>e", vim.diagnostic.open_float, "Show Diagnostic Window")

          -- map('<leader>q', vim.diagnostic.setloclist)

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup("lsp-attach", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "lsp-attach", buffer = event2.buf })
              end,
            })
          end

          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "[T]oggle Inlay [H]ints")
          end
        end,
      })

      -- Global border for all floating windows (Neovim 0.11+)
      vim.o.winborder = "rounded"

      -- Global LSP config: capabilities (Neovim 0.11+)
      vim.lsp.config("*", {
        capabilities = vim.tbl_deep_extend(
          "force",
          vim.lsp.protocol.make_client_capabilities(),
          require("blink.cmp").get_lsp_capabilities({}, false)
        ),
      })

      -- Per-server configurations via vim.lsp.config (Neovim 0.11+)
      -- Replaces the deprecated require("lspconfig")[server].setup() pattern
      vim.lsp.config("yamlls", {
        filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
        settings = {
          yaml = {
            validate = true,
            schemaStore = {
              enable = false,
            },
            schemas = vim.tbl_extend("force", require("schemastore").yaml.schemas(), {
              ["https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json"] = "**/argo-cd/applications/**/*.{yml,yaml}",
              ["https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/applicationset_v1alpha1.json"] = "**/argo-cd/applicationsets/**/*.{yml,yaml}",
              ["https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/appproject_v1alpha1.json"] = "**/argo-cd/appprojects/**/*.{yml,yaml}",
            }),
            customTags = {
              "!ignore status",
            },
          },
        },
      })

      vim.lsp.config("helm_ls", {
        handlers = {
          ["textDocument/publishDiagnostics"] = function(err, result, ctx)
            if result and result.diagnostics then
              result.diagnostics = vim.tbl_filter(function(d)
                return not (d.source and d.source:match("^yaml%-schema:"))
              end, result.diagnostics)
            end
            vim.lsp.handlers["textDocument/publishDiagnostics"](err, result, ctx)
          end,
        },
      })

      vim.lsp.config("ansiblels", {
        settings = {
          ansible = {
            ansible = {
              path = "ansible",
            },
            validation = {
              lint = {
                enabled = true,
                path = "ansible-lint",
              },
            },
          },
        },
      })

      -- lazydev.nvim handles Neovim runtime paths automatically,
      -- so workspace.library is not needed here
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
            diagnostics = {
              globals = { "vim", "awesome", "client", "fs", "Command" },
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })

      require("mason").setup()

      -- Formatters/linters (not LSP servers) via mason-tool-installer
      require("mason-tool-installer").setup({
        ensure_installed = {
          "stylua",
          "yamlfmt",
        },
      })

      -- mason-lspconfig v2: automatic_enable replaces the removed handlers{} API
      require("mason-lspconfig").setup({
        ensure_installed = {
          "pyright",
          "terraformls",
          "gopls",
          "ts_ls",
          "texlab",
          "ansiblels",
          "yamlls",
          "helm_ls",
          "lua_ls",
        },
        automatic_enable = true,
      })

      vim.diagnostic.config({
        virtual_text = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "󰋼",
            [vim.diagnostic.severity.HINT] = "",
          },
          numhl = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
          },
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = true,
          header = "",
          prefix = "",
        },
      })
    end,
  },
  {
    "towolf/vim-helm",
    ft = "helm",
  },
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup({
        run_in_floaterm = true,
        floaterm = {
          posititon = "bottom",
          height = 0.25,
        },
      })
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
  },
}
