local cmp = require 'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
    ['<C-j>'] = cmp.mapping.select_next_item({ behavior = 'select' }),
    ['<Tab>'] = cmp.mapping.select_next_item({ behavior = 'select' }),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
  }),
  sources = cmp.config.sources({
      { name = 'nvim_lsp' },
    },
    {
      { name = 'buffer' },
    }),
  preselect = 'item',
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
})

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})

require('cmp_nvim_lsp').default_capabilities()

-- --------------------------
-- Highlight group definitions (Ensure these run AFTER your colorscheme is set)
-- --------------------------
local normal_float_hl = vim.api.nvim_get_hl_by_name("NormalFloat", true) or {}
local float_border_hl = vim.api.nvim_get_hl_by_name("FloatBorder", true) or {}
local pmenu_hl = vim.api.nvim_get_hl_by_name("Pmenu", true) or {}
local pmenu_sel_hl = vim.api.nvim_get_hl_by_name("PmenuSel", true) or {}

-- Define/override CMP related highlight groups if you want specific colors
-- Use the colors from existing highlight groups for consistency
vim.api.nvim_set_hl(0, "NormalFloat", { fg = pmenu_hl.fg, bg = pmenu_hl.bg })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = float_border_hl.fg or pmenu_hl.fg, bg = float_border_hl.bg or pmenu_hl.bg })
vim.api.nvim_set_hl(0, "Pmenu", { fg = pmenu_hl.fg, bg = pmenu_hl.bg })
vim.api.nvim_set_hl(0, "PmenuSel", { fg = pmenu_sel_hl.fg, bg = pmenu_sel_hl.bg }) -- Adjusted to use colors from pmenu_sel

-- Explicitly define `GruvboxOrange` if you want a specific orange for the border
-- or query an existing one like `Statement` or `Constant` that might have an orange tint
local gruvbox_orange_bg = pmenu_hl
    .bg                                                                             -- or a different background color like colors.bg1 if you know it
vim.api.nvim_set_hl(0, "GruvboxOrange", { fg = "#fabd2f", bg = gruvbox_orange_bg }) -- Using hex for orange, and existing bg

local set_hl = vim.api.nvim_set_hl
local cmp_item_fg = pmenu_hl.fg -- or use a specific color like "#fabd2f"

set_hl(0, "CmpItemAbbr", { fg = cmp_item_fg })
set_hl(0, "CmpItemAbbrMatch", { fg = cmp_item_fg, bold = true })
set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = cmp_item_fg, italic = true })
set_hl(0, "CmpItemMenu", { fg = cmp_item_fg, italic = true })
set_hl(0, "CmpItemKind", { fg = cmp_item_fg })

vim.cmd([[autocmd ColorScheme * highlight FloatBorder guifg=GruvboxOrange guibg=NormalFloat]]) -- Link FloatBorder to GruvboxOrange fg and NormalFloat bg
