return {
	{
		"sainnhe/sonokai",
		priority = 1000, -- load before other plugins
		config = function()
			-- Sonokai setup
			vim.g.sonokai_style = "andromeda" -- options: default, andromeda, atlantis, shusia, maia, espresso
			vim.g.sonokai_enable_italic = 1
			vim.g.sonokai_disable_background = 1 -- removes Sonokai's bg

			vim.cmd.colorscheme("sonokai")

			-- -- Force transparency
			-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
			-- vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" }) -- inactive windows
			-- vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
			-- vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
			-- -- NvimTree transparency
			-- vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
			-- vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = "none" })

            -- =======================
			-- Transparency Handling
			-- =======================
			local transparent_enabled = true

			local function set_transparency()
				if not transparent_enabled then
					-- reset to default colorscheme
					vim.cmd("silent! colorscheme sonokai")
					return
				end

				-- Global UI
				vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
				vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
				vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
				vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
				vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })

				-- NvimTree explorer
				vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
				vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = "none" })
				vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "none" })

				-- Telescope popups
				vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
				vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
			end

			-- Apply on load
			set_transparency()

			-- Reapply after colorscheme changes
			vim.api.nvim_create_autocmd("ColorScheme", {
				callback = set_transparency,
			})

			-- Toggle with <leader>tt
			vim.keymap.set("n", "<leader>tt", function()
				transparent_enabled = not transparent_enabled
				set_transparency()
				if transparent_enabled then
					vim.notify("Transparency enabled", vim.log.levels.INFO)
				else
					vim.notify("Transparency disabled", vim.log.levels.INFO)
				end
			end, { desc = "Toggle Transparency" })

		end,

	},
}
