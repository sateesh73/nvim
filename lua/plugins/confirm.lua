return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = true }, function(err, did_edit)
					if not err and did_edit then
						vim.notify("Code formatted", vim.log.levels.INFO, { title = "Conform" })
					end
				end)
			end,
			mode = { "n", "v" },
			desc = "Format buffer",
		},
	},
	opts = {
		format_on_save = function(bufnr)
			local disable_lsp_fallback = {
				java = true, -- Add java here to prioritize conform's formatter
			}
			return {
				timeout_ms = 500,
				lsp_format = disable_lsp_fallback[vim.bo[bufnr].filetype] and "never" or "fallback",
			}
		end,
		formatters_by_ft = {
			-- Lua
			lua = { "stylua" },

			-- Web technologies
			javascript = { "prettier" },
			typescript = { "prettier" },
			javascriptreact = { "prettier" },
			typescriptreact = { "prettier" },
			json = { "prettier" },
			jsonc = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier" },
			html = { "prettier" },
			css = { "prettier" },
			scss = { "prettier" },

			-- Python
			python = { "isort", "black" },
			java = { "google-java-format" },

			-- Additional file types (uncomment as needed)
			-- markdown = { "markdownlint" },
			-- yaml = { "yamllint" },
			-- toml = { "taplo" },
		},
		default_format_opts = {
			lsp_format = "fallback",
		},
		-- format_on_save = {
		--     timeout_ms = 1000,
		--     lsp_format = "fallback",
		-- },
	},
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
