return {
	"folke/noice.nvim",
	opts = {
		-- Route command-line and search to a popup
		cmdline = {
			view = "cmdline_popup",
		},
		-- Control presets to prevent bottom-bar behavior
		presets = {
			bottom_search = true, -- Search popup is at the top
			command_palette = true, -- Command popup is separate
			long_message_to_split = true, -- Long messages go to a split
		},
	},
}
