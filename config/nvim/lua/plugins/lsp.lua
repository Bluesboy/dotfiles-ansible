return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup({
        ensure_installed = {
          "typescript-language-server",
        },
      })
    end,
  },
  {
    "someone-stole-my-name/yaml-companion.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function(_, opts)
      local cfg = require("yaml-companion").setup(opts)
      require("lspconfig")["yamlls"].setup(cfg)
      require("telescope").load_extension("yaml_schema")
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "pyright",
          "terraformls",
          "yamlls",
          "helm_ls",
          "gopls",
          "ts_ls",
          "ansiblels",
        },
        auto_install = true,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "towolf/vim-helm",
      "b0o/schemastore.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")

      local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
      }

      for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
      end

      local lua_ls_setup = {
        settings = {
          Lua = {
            diagnostics = {
              globals = {
                "vim",
                "awesome",
                "client",
              },
            },
            workspace = {
              library = {
                vim.api.nvim_get_runtime_file("", true),
                vim.fn.expand("$VIMRUNTIME/lua"),
                vim.fn.expand("$XDG_CONFIG_HOME") .. "/nvim/lua",
                vim.fn.expand("/usr/share/awesome/lib"),
              },
            },
            telemetry = {
              enable = false,
            },
            globals = {
              "awesome",
              "client",
            },
          },
        },
      }

      lspconfig.helm_ls.setup({
        settings = {
          ["helm-ls"] = {
            yamlls = {
              path = "yaml-language-server",
            },
          },
        },
      })

      lspconfig.yamlls.setup({
        settings = {
          yaml = {
            hover = true,
            completion = true,
            validate = true,
            schemaStore = {
              enable = false,
              url = "",
            },
            schemas = require("schemastore").yaml.schemas({
              extra = {
                {
                  name = "kubernetes",
                  description = "Kubernetes",
                  fileMatch = { "*.yaml", "*.yml" },
                  url = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.31.1/_definitions.json",
                },
              },
            }),
            singleQuote = true,
          },
        },
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      lspconfig.lua_ls.setup(lua_ls_setup)

      lspconfig.gopls.setup({})

      lspconfig.pyright.setup({
        capabilities = capabilities,
      })

      lspconfig.ts_ls.setup({})

      lspconfig.ansiblels.setup({})

      lspconfig.terraformls.setup({
        capabilities = capabilities,
      })

      -- Format before writing terraform files
      vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        pattern = { "*.tf", "*.tfvars" },

        callback = function()
          vim.lsp.buf.format()
        end,
      })

      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
      -- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "gk", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
          end, opts)
          vim.keymap.set("n", "gn", function()
            vim.diagnostic.goto_next({ buffer = 0 })
          end, opts)
          vim.keymap.set("n", "gp", function()
            vim.diagnostic.goto_prev({ buffer = 0 })
          end, opts)
        end,
      })

      local config = {
        virtual_text = true, -- enable virtual text
        signs = {
          active = signs,    -- show signs
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      }

      vim.diagnostic.config(config)

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        -- Use a sharp border with `FloatBorder` highlights
        border = "single",
        -- add the title in hover float window
        title = "hover",
      })
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
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
