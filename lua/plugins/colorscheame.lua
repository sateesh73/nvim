return {
	{
		"sainnhe/gruvbox-material",
		enabled = true,
		priority = 1000,
		config = function()
			vim.g.gruvbox_material_transparent_background = 1
			vim.g.gruvbox_material_foreground = "mix"
			vim.g.gruvbox_material_background = "hard"
			vim.g.gruvbox_material_ui_contrast = "high"
			vim.g.gruvbox_material_float_style = "bright"
			vim.g.gruvbox_material_statusline_style = "mix" -- Options: "original", "material", "mix", "afterglow"
			vim.g.gruvbox_material_cursor = "auto"

			vim.cmd.colorscheme("gruvbox-material")

			-- Custom statusline highlights
			-- vim.api.nvim_set_hl(0, "StatusLine", {
			--   bg = "#1C2021", -- Dark gray background
			--   fg = "#ebdbb2", -- Light text
			--   bold = false
			-- })
			--
			-- vim.api.nvim_set_hl(0, "StatusLineNC", {
			--   bg = "#1C2021", -- Darker background for inactive windows
			--   fg = "#928374", -- Muted text
			--   bold = false
			-- })
		end,
	},
}
