local term_opts = { silent = true }

-- Shorten function name
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

--Remap space as leader key
map("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Resize with arrows
map("n", "<C-Up>", "<cmd>resize +2<CR>")
map("n", "<C-Down>", "<cmd>resize -2<CR>")
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>")
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>")

-- Navigate buffers
map("n", "<S-l>", "<cmd>bnext<CR>")
map("n", "<S-h>", "<cmd>bprevious<CR>")

-- Insert --
-- Press jk fast to enter
map("i", "jk", "<ESC>")

-- Visual --
-- Stay in indent mode
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Paste without overriding buffer
map("v", "p", '"_dP')

-- Visual Block --
-- Move text up and down
map("x", "J", "<cmd>move '>+1<CR>gv-gv")
map("x", "K", "<cmd>move '<-2<CR>gv-gv")
map("x", "<A-j>", "<cmd>move '>+1<CR>gv-gv")
map("x", "<A-k>", "<cmd>move '<-2<CR>gv-gv")

-- Terminal --
-- Better terminal navigation
map("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
map("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
map("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
map("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Leader write, quit and both
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save buffer" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Exit Neovim. Finally!" })
map("n", "<leader>x", "<cmd>q!<CR>", { desc = "Exit without saving" })
map("n", "<leader>Q", "<cmd>wq<CR>", { desc = "Save buffer and exit" })

-- Quickfix navigation
map("n", "]q", "<CMD>cnext<CR>", { desc = "Next QF record" })
map("n", "[q", "<CMD>cprev<CR>", { desc = "Prev QF record" })

map("n", "<leader>lq", "<CMD>copen<CR>", { desc = "Open Quickfix" })
map("n", "<leader>ll", "<CMD>lopen<CR>", { desc = "Open Location list" })
map("n", "gq", function()
  vim.diagnostic.setqflist()
end, { desc = "Put to Quickfix" })
map("n", "gl", function()
  vim.diagnostic.setloclist()
end, { desc = "Put to Location list" })

-- Backspace turn off search highlight
map("n", "<BS>", "<cmd>nohlsearch<CR>", { desc = "Disable search highlight" })

-- ToggleTerm
map({ "n", "t" }, "<C-s>", "<cmd>ToggleTerm<CR>", { desc = "Toggle Terminal" })
map("n", "<S-t>", function()
  require("user.functions.tmux").open_or_focus()
end, { desc = "Focus tmux bottom pane" })

-- WhichKey
map({ "n", "i" }, "<C-_>", "<cmd>WhichKey<CR>", { desc = "Show WhichKey" })

-- GitPortal
map("n", "<leader>gb", "<cmd>GitPortal browse_file<CR>", { desc = "Show file on Remote" })
map(
  { "n", "v" },
  "<leader>gc",
  "<cmd>GitPortal copy_link_to_clipboard<CR>",
  { desc = "Copy link to file in clipboard" }
)

-- Golang
map("n", "<F5>", "<cmd>GoRun<CR>")

-- Dotfiles AUR helper
map("n", "<leader>pd", require("user.functions.aur").insert_description)

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Absolute numbers toggle
map({ "n", "t" }, "<C-n>", function()
  vim.o.relativenumber = not vim.o.relativenumber
end, { desc = "Toggle absolute numbers" })

-- Diagnostic toggle
map({ "n" }, "<leader>dd", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostic" })

-- MarkDownPreview
map({ "n", "i" }, "gm", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Toggle Markdown Preview" })

-- Maximize
map("n", "<leader>o", function()
  require("maximize").toggle()
end, { desc = "Maximize/Restore Window" })

-- Kubectl
map("n", "<leader>k", function()
  require("kubectl").toggle({})
end, { desc = "Maximize/Restore Window" })
