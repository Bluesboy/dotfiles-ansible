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

-- Normal --


-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move focus to the left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move focus to the upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move focus to the right window" })

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

-- Backspace turn off search highlight
map("n", "<BS>", "<cmd>nohlsearch<CR>", { desc = "Disable search highlight" })

-- ToggleTerm
map({ "n", "t" }, "<C-s>", "<cmd>ToggleTerm<CR>", { desc = "Toggle Terminal" })

-- WhichKey
map({ "n", "i" }, "<C-_>", "<cmd>WhichKey<CR>", { desc = "Show WhichKey" })

-- Golang
map("n", "<F5>", "<cmd>GoRun<CR>")

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
