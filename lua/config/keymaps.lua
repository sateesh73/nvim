-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("i", "jj", "<ESC>", { silent = true })
vim.keymap.set("i", "jk", "<ESC>", { silent = true })
vim.keymap.set("n", "pp", "yyp", { silent = true })
vim.keymap.set("n", "qq", ":q<CR>", { noremap = true, silent = true, desc = "Quit file" })
vim.keymap.set("n", "ww", ":w<CR>", { noremap = true, silent = true, desc = "Save file" })
