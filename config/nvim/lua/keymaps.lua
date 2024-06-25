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

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --

map("n", "<leader>sf", ":source %<cr>")

-- Better window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Resize with arrows
map("n", "<C-Up>", ":resize +2<cr>")
map("n", "<C-Down>", ":resize -2<cr>")
map("n", "<C-Left>", ":vertical resize -2<cr>")
map("n", "<C-Right>", ":vertical resize +2<cr>")

-- Navigate buffers
map("n", "<S-l>", ":bnext<cr>")
map("n", "<S-h>", ":bprevious<cr>")

-- Insert --
-- Press jk fast to enter
map("i", "jk", "<ESC>")

-- Visual --
-- Stay in indent mode
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move text up and down
map("v", "<A-j>", ":m .+1<cr>==")
map("v", "<A-k>", ":m .-2<cr>==")
map("v", "p", '"_dP')

-- Visual Block --
-- Move text up and down
map("x", "J", ":move '>+1<cr>gv-gv")
map("x", "K", ":move '<-2<cr>gv-gv")
map("x", "<A-j>", ":move '>+1<cr>gv-gv")
map("x", "<A-k>", ":move '<-2<cr>gv-gv")

-- Terminal --
-- Better terminal navigation
map("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
map("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
map("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
map("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Leader write, quit and both
map("n", "<leader>w", ":w<cr>")
map("n", "<leader>q", ":q<cr>")
map("n", "<leader>x", ":q!<cr>")
map("n", "<leader>Q", ":wq<cr>")

-- Telescope
map("n", "<C-f>", "<cmd>Telescope find_files<cr>")
map("n", "<C-t>", "<cmd>Telescope live_grep<cr>")

-- Backspace turn off search highlitning
map("n", "<BS>", ":nohlsearch<cr>")

-- Nvimtree
map("n", "<C-n>", ":Neotree toggle<cr>")

-- Null-ls
map("n", "<leader>f", "<cmd>lua vim.lsp.buf.format()<cr>")
map("v", "<leader>f", "<cmd>lua vim.lsp.buf.range_format()<cr>")

-- ToggleTerm
map({ "n", "t" }, "<C-s>", "<cmd>ToggleTerm<cr>")
map("n", "<M-g>", "<cmd>lua _LAZYGIT_TOGGLE()<cr>")

-- WhichKey
map({ "n", "i" }, "<C-_>", "<cmd>WhichKey<cr>")

-- GitBlame
map("n", "<leader>b", "<cmd>GitBlameToggle<cr>")
