local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})

-- Install your plugins here
return packer.startup(function(use)
  -- Basic Plugins
  use("wbthomason/packer.nvim") -- Have packer manage itself
  use("nvim-lua/popup.nvim") -- An implementation of the Popup API from vim in Neovim
  use("nvim-lua/plenary.nvim") -- Useful lua functions used by lots of plugins
  use("windwp/nvim-autopairs") -- Autopairs, integrates with both cmp and treesitter
  use("numToStr/Comment.nvim") -- Easily comment stuff
  use("ethanholz/nvim-lastplace")
  use("kyazdani42/nvim-web-devicons")
  use("kyazdani42/nvim-tree.lua")
  use({
    "akinsho/bufferline.nvim",
    branch = "main",
  })
  use("moll/vim-bbye")
  use({
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  })

  -- Colorscheme
  use("projekt0n/github-nvim-theme")
  use("norcalli/nvim-colorizer.lua")
  --
  -- Transparent
  use("xiyaowong/transparent.nvim")

  -- Lualine
  use({
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
    config = function()
      require("lualine").setup({
        options = {
          theme = "powerline",
        },
      })
    end,
  })

  -- cmp plugins
  use("hrsh7th/nvim-cmp") -- The completion plugin
  use("hrsh7th/cmp-buffer") -- buffer completions
  use("hrsh7th/cmp-path") -- path completions
  use("hrsh7th/cmp-cmdline") -- cmdline completions
  use("saadparwaiz1/cmp_luasnip") -- snippet completions
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-nvim-lua")

  -- snippets
  use("L3MON4D3/LuaSnip") --snippet engine
  use("rafamadriz/friendly-snippets") -- a bunch of snippets to use

  -- LSP
  use("neovim/nvim-lspconfig") -- enable LSP
  use({
    "williamboman/mason.nvim", -- Easily install and manage LSP servers, DAP servers, linters, and formatters.
    run = function()
      pcall(vim.cmd, "MasonUpdate")
    end,
  })
  use("williamboman/mason-lspconfig.nvim")
  use("jose-elias-alvarez/null-ls.nvim") -- for formatters and linters

  -- Telescope
  use("nvim-telescope/telescope.nvim")
  use("nvim-telescope/telescope-media-files.nvim")

  -- Treesitter
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  })
  use("JoosepAlviste/nvim-ts-context-commentstring")
  use("nvim-treesitter/playground")

  -- Git
  use("lewis6991/gitsigns.nvim")

  -- Tmux integration
  use({
    "aserowy/tmux.nvim",
    config = function()
      require("tmux").setup({
        copy_sync = {
          enable = true,
        },
        navigation = {
          enable_default_keybindings = true,
        },
        resize = {
          enable_default_keybindings = true,
        },
      })
    end,
  })

  -- Toggleterm
  use({
    "akinsho/nvim-toggleterm.lua",
    branch = "main",
  })

  -- Indentation
  use("lukas-reineke/indent-blankline.nvim")


  -- Markdown Preview
  -- install without yarn or npm
  use({
    "iamcco/markdown-preview.nvim",
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
  })

  use({
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    setup = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  })

  use({
    "someone-stole-my-name/yaml-companion.nvim",
    requires = {
      { "neovim/nvim-lspconfig" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      require("telescope").load_extension("yaml_schema")
    end,
  })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
  use({
    "NeogitOrg/neogit",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" }
    }
  })
end)
