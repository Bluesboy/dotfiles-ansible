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
map("n", "<leader>sf", ":source %<CR>") -- Source currnt file

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move focus to the left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move focus to the upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move focus to the right window" })

-- Resize with arrows
map("n", "<C-Up>", ":resize +2<CR>")
map("n", "<C-Down>", ":resize -2<CR>")
map("n", "<C-Left>", ":vertical resize -2<CR>")
map("n", "<C-Right>", ":vertical resize +2<CR>")

-- Navigate buffers
map("n", "<S-l>", ":bnext<CR>")
map("n", "<S-h>", ":bprevious<CR>")

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
map("x", "J", ":move '>+1<CR>gv-gv")
map("x", "K", ":move '<-2<CR>gv-gv")
map("x", "<A-j>", ":move '>+1<CR>gv-gv")
map("x", "<A-k>", ":move '<-2<CR>gv-gv")

-- Terminal --
-- Better terminal navigation
map("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
map("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
map("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
map("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Leader write, quit and both
map("n", "<leader>w", ":w<CR>", { desc = "Save buffer" })
map("n", "<leader>q", ":q<CR>", { desc = "Exit Neovim. Finally!" })
map("n", "<leader>x", ":q!<CR>", { desc = "Exit without saving" })
map("n", "<leader>Q", ":wq<CR>", { desc = "Save buffer and exit" })

-- Backspace turn off search highlight
map("n", "<BS>", ":nohlsearch<CR>", { desc = "Disable search highlight" })

-- Telescope
map("n", "<C-f>", "<cmd>Telescope find_files<CR>")
map("n", "<C-t>", "<cmd>Telescope live_grep<CR>")

-- Null-ls
map("n", "<leader>f", "<cmd>lua vim.lsp.buf.format()<CR>")
map("v", "<leader>f", "<cmd>lua vim.lsp.buf.range_format()<CR>")

-- ToggleTerm
map({ "n", "t" }, "<C-s>", "<cmd>ToggleTerm<CR>", { desc = "Toggle Terminal" })

-- WhichKey
map({ "n", "i" }, "<C-_>", "<cmd>WhichKey<CR>", { desc = "Show WhichKey" })

-- GitBlame
map("n", "<leader>b", "<cmd>GitBlameToggle<CR>", { desc = "Toggle GitBlame" })

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
