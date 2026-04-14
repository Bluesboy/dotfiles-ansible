return {
  {
    "rmagatti/goto-preview",
    dependencies = { "rmagatti/logger.nvim" },
    event = { "BufEnter", "LspAttach" },
    config = true,
  },
}
