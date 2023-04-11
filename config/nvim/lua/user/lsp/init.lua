local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
    return
end

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
    "lua_ls",
    "tsserver",
    "bashls",
    "ansiblels",
    "dockerls",
    "gopls",
    "jsonls",
    "pylsp",
    "yamlls"
  }
})
