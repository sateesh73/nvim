require("config.lazy")

vim.opt.termguicolors = true
vim.opt.clipboard = 'unnamedplus'

local function close_buffer()
  local bufferline = require("bufferline")
  local current_buf = vim.api.nvim_get_current_buf()
  local buffers = bufferline.get_elements().elements

  local is_tab = false
  for _, buf in ipairs(buffers) do
    if buf.id == current_buf then
      is_tab = true
      break
    end
  end

  if not is_tab then
    vim.cmd("bdelete")
    return
  end

  if #buffers > 1 then
    vim.cmd("confirm bdelete")
  end
end

--help files open in full window and are listed in buffer elements
vim.api.nvim_create_autocmd("FileType", {
  pattern = "help",
  callback = function()
    vim.cmd("only")
    vim.bo.buflisted = true
  end
})

--disable netrrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.wo.relativenumber = true
vim.o.winborder = 'rounded' -- Global border for floating windows (Nvim 0.11+)
-- vim.keymap.set("n", "<Tab>", function()
--   require("oil").open()
-- end)
vim.keymap.set("n", "<leader>e", function()
  require("oil").open()
end, { desc = "Open Oil (File Explorer)" })

-- Move line up in normal mode
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { silent = true })
-- Move line down in normal mode
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { silent = true })

-- Move selection up in visual mode
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { silent = true })
-- Move selection down in visual mode
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { silent = true })

--unhighlight
vim.keymap.set("n", "<C-h>", ":noh<CR>", { silent = true })

--terminal
vim.keymap.set("n", [[<A-\>]], ":terminal<CR>i")
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])

local term = require("config.floaterminal")
vim.keymap.set("n", "<A-\\>", term.open, { noremap = true, silent = true, desc = "Open floating terminal" })
--saving&quitting
vim.keymap.set("n", "<F5>", ":w<CR>")
vim.keymap.set("n", "<F6>", ":wa<CR>")
vim.keymap.set("n", "<BS>", close_buffer)
vim.keymap.set("n", "<A-BS>", ":qa<CR>")
vim.keymap.set("i", "jj", "<ESC>", { silent = true })
vim.keymap.set("i", "jk", "<ESC>", { silent = true })
vim.keymap.set("n", "pp", "yyp", { silent = true })
vim.keymap.set("n", "qq", ":q<CR>", { noremap = true, silent = true, desc = "Quit file" })
vim.keymap.set("n", "ww", ":w<CR>", { noremap = true, silent = true, desc = "Save file" })
--bufferline
vim.keymap.set('n', '<A-,>', ':BufferLineCyclePrev<CR>')
vim.keymap.set('n', '<A-.>', ':BufferLineCycleNext<CR>')

--copilot
vim.keymap.set('i', '<C-e>', '<Plug>(copilot-dismiss)')
vim.keymap.set({ "n", "v" }, "~", ":CopilotChat<CR>")
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "copilot-chat",
  callback = function()
    vim.cmd("wincmd r")
  end,
})

--telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

local treesitter = require('treesitter.treesitter_setup')
treesitter.setup()
