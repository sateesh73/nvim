return {
	{
		"romgrk/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
			"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
		},
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		opts = {
			-- Barbar options
			animation = true,
			auto_hide = false,
			tabpages = true,
			clickable = true,
			icons = {
				filetype = { enabled = true }, -- show filetype icons
				modified = { button = "●" },
				pinned = { button = "車", filename = true },
			},
			sidebar_filetypes = {
				-- This offsets the bar when file explorer is open
				["NvimTree"] = { text = "Explorer", align = "left" },
			},
			-- Only show the filename, not full path
			maximum_padding = 1,
			minimum_padding = 1,
			tab_size = 18,
		},
		version = "^1.0.0",
	},
}
