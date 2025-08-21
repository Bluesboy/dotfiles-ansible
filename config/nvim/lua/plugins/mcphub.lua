return {
  "ravitemer/mcphub.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  build = "npm install -g mcp-hub@latest",
  config = function()
    require("mcphub").setup({
      port = 3000,
      config = vim.fn.expand("~/.config/nvim/mcpservers.json"),
      log = {
        level = vim.log.levels.WARN,
        to_file = true,
      },
      on_ready = function()
        vim.notify("MCP Hub backend server is initialized and ready.", vim.log.levels.INFO)
      end,
    })
  end,
}
