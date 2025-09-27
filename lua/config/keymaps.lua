local opts = { noremap = true, silent = true}
local map = vim.keymap.set

-- map('n', '<leader>e', ':Ex<CR>')
map("n", "<TAB>", function()
  require("oil").open()
end, { desc = "Open Oil (File Explorer)" })
-- Move selected line / block of text in visual mode
map("v", "K", ":m '<-2<CR>gv=gv", opts)
map("v", "J", ":m '>+1<CR>gv=gv", opts)
-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")
-- paste over currently selected text without yanking it
map("v", "p", '"_dp')
map("v", "P", '"_dP')
-- copy everything between { and } including the brackets
-- p puts text after the cursor,
-- P puts text before the cursor.
map("n", "YY", "va{Vy", opts)
-- Exit on jj and jk
map("i", "jj", "<ESC>", opts)
map("i", "jk", "<ESC>", opts)
map({"i", "n"}, "ww", "<ESC>:w<CR>", opts)
map({"i", "n"}, "qq", "<ESC>:q<CR>", opts)
map({"i", "n"}, "pp", "<ESC>yyp", opts)
-- Navigate buffers
-- map("n", "<Right>", ":bnext<CR>", opts)
-- map("n", "<Left>", ":bprevious<CR>", opts)
map("n", "n", "nzzv", opts)
map("n", "N", "Nzzv", opts)
map("n", "*", "*zzv", opts)
map("n", "#", "#zzv", opts)
map("n", "g*", "g*zz", opts)
map("n", "g#", "g#zz", opts)
-- Split line with X
map("n", "X", ":keeppatterns substitute/\\s*\\%#\\s*/\\r/e <bar> normal! ==^<cr>", { silent = true })
-- ctrl + x to cut full line
map("n", "<C-x>", "dd", opts)
-- Select all
map("n", "<C-a>", "ggVG", opts)
-- write file in current directory
-- :w %:h/<new-file-name>
map("n", "<C-n>", ":w %:h/", opts)
-- open floating terminal
map("n", "<C-t>", ':lua require("config.utils").open_term()<CR>', opts)
map("n", "<Esc>", ":nohlsearch<CR>", opts)
-- Get highlighted line numbers in visual mode
map("v", "<leader>ln", ':lua require("config.utils").get_highlighted_line_numbers()<CR>', opts)
