return {
  "monaqa/dial.nvim",
  keys = { "<C-a>", "<C-x>" },
  config = function()
    local augend = require("dial.augend")
    require("dial.config").augends:register_group({
      default = {
        augend.constant.alias.bool,
        augend.integer.alias.decimal_int,
        augend.date.alias["%d.%m.%Y"],
        augend.semver.alias.semver,
        augend.constant.new({
          elements = { "debug", "info", "warn", "error" },
          cyclic = true,
        }),
      },
    })
    vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(), { noremap = true })
    vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true })
  end,
}
