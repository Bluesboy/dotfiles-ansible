local opts = { noremap = true, silent = true }

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
map("", "<Space>", "<Nop>", opts)
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

map("n", "<leader>sf", ":source %<cr>", opts)
-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

map("n", "<leader>e", ":Lex 30<cr>", opts)

-- Resize with arrows
map("n", "<C-Up>", ":resize +2<cr>", opts)
map("n", "<C-Down>", ":resize -2<cr>", opts)
map("n", "<C-Left>", ":vertical resize -2<cr>", opts)
map("n", "<C-Right>", ":vertical resize +2<cr>", opts)

-- Navigate buffers
map("n", "<S-l>", ":bnext<cr>", opts)
map("n", "<S-h>", ":bprevious<cr>", opts)

-- Insert --
-- Press jk fast to enter
map("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Move text up and down
map("v", "<A-j>", ":m .+1<cr>==", opts)
map("v", "<A-k>", ":m .-2<cr>==", opts)
map("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
map("x", "J", ":move '>+1<cr>gv-gv", opts)
map("x", "K", ":move '<-2<cr>gv-gv", opts)
map("x", "<A-j>", ":move '>+1<cr>gv-gv", opts)
map("x", "<A-k>", ":move '<-2<cr>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
map("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
map("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
map("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
map("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Leader write, quit and both
map("n", "<leader>w", ":w<cr>", opts)
map("n", "<leader>q", ":q<cr>", opts)
map("n", "<leader>x", ":q!<cr>", opts)
map("n", "<leader>Q", ":wq<cr>", opts)

-- Telescope
map("n", "<C-f>", "<cmd>Telescope find_files<cr>", opts)
map("n", "<C-t>", "<cmd>Telescope live_grep<cr>", opts)

-- Backspace turn off search highlitning
map("n", "<BS>", ":nohlsearch<cr>", opts)

-- Nvimtree
map("n", "<C-n>", ":Neotree toggle<cr>", opts)

-- Null-ls
map("n", "<leader>f", "<cmd>lua vim.lsp.buf.format()<cr>", opts)
map("v", "<leader>f", "<cmd>lua vim.lsp.buf.range_format()<cr>", opts)

-- -- Bufferline
-- keymap("n", "<leader><tab>", ":BufferLineCycleNext<cr>", opts)
-- keymap("n", "<leader><Backspace>", ":BufferLineCyclePrev<cr>", opts)

-- ToggleTerm
map({ "n", "t" }, "<C-s>", "<cmd>ToggleTerm<cr>", opts)
map("n", "<M-g>", "<cmd>lua _LAZYGIT_TOGGLE()<cr>", opts)

-- WhichKey
-- keymap("n", "<C-_>", "<cmd>WhichKey<cr>", opts)
map({ "n", "i" }, "<C-_>", "<cmd>WhichKey<cr>", opts)
