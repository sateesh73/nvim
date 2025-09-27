return {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lua",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			{
				"rafamadriz/friendly-snippets",
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local cmp_enabled = true

			vim.keymap.set("n", "<leader>ta", function()
				cmp_enabled = not cmp_enabled
				vim.notify("Autocomplete " .. (cmp_enabled and "ENABLED" or "DISABLED"))
			end, { desc = "Toggle autocomplete" })

			-- keep the tail of a long string (left-ellipsis)
			local function tail(s, n)
				if not s or s == "" then
					return ""
				end
				if #s <= n then
					return s
				end
				return "…" .. s:sub(#s - n + 1)
			end

			-- Helper to fetch Gruvbox Material colors dynamically
			local function get_fg(group)
				local hl = vim.api.nvim_get_hl(0, { name = group })
				return hl and hl.fg or nil
			end

			local function get_bg(group)
				local hl = vim.api.nvim_get_hl(0, { name = group })
				return hl and hl.bg or nil
			end
			----------------------
			-- Modern highlights, mapped to Gruvbox Material groups
			vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { strikethrough = true, fg = get_fg("Comment") })
			vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { bold = true, fg = get_fg("Identifier") })
			vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { bold = true, fg = get_fg("Identifier") })

			vim.api.nvim_set_hl(0, "CmpItemMenu", { italic = true, fg = get_fg("Comment") })
			vim.api.nvim_set_hl(0, "CmpItemKind", { fg = get_fg("Function") })

			-- Border & popup background
			vim.api.nvim_set_hl(0, "CmpBorder", { fg = get_fg("FloatBorder") })
			vim.api.nvim_set_hl(0, "CmpSel", { bg = get_bg("Visual") })
			vim.api.nvim_set_hl(0, "CmpDoc", { bg = get_bg("NormalFloat") })

			-- Kinds mapped to Gruvbox groups
			vim.api.nvim_set_hl(0, "CmpItemKindClass", { fg = get_fg("Type") })
			vim.api.nvim_set_hl(0, "CmpItemKindInterface", { fg = get_fg("Identifier") })
			vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = get_fg("Function") })
			vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = get_fg("Function") })
			vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = get_fg("Identifier") })
			vim.api.nvim_set_hl(0, "CmpItemKindField", { fg = get_fg("Identifier") })
			vim.api.nvim_set_hl(0, "CmpItemKindProperty", { fg = get_fg("Identifier") })
			vim.api.nvim_set_hl(0, "CmpItemKindConstant", { fg = get_fg("Constant") })
			vim.api.nvim_set_hl(0, "CmpItemKindEnum", { fg = get_fg("Type") })
			vim.api.nvim_set_hl(0, "CmpItemKindEnumMember", { fg = get_fg("Constant") })
			vim.api.nvim_set_hl(0, "CmpItemKindStruct", { fg = get_fg("Type") })
			vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = get_fg("Keyword") })
			vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = get_fg("String") })
			vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = get_fg("Normal") })
			vim.api.nvim_set_hl(0, "CmpItemKindModule", { fg = get_fg("Include") })
			vim.api.nvim_set_hl(0, "CmpItemKindFile", { fg = get_fg("Directory") })
			----------------------
			cmp.setup({
				preselect = cmp.PreselectMode.Item,
				enabled = function()
					local context = require("cmp.config.context")
					-- disable in comments/prompt buffers
					if context.in_treesitter_capture("comment") or context.in_syntax_group("Comment") then
						return false
					end
					local bt = vim.api.nvim_get_option_value("buftype", { buf = 0 })
					return cmp_enabled and bt ~= "prompt"
				end,
				completion = { completeopt = "menu,menuone,noinsert" },
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					completion = {
						border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
						scrollbar = false,
						col_offset = -3,
						-- side_padding = 1, -- minimal padding for clean look
						side_padding = 0,
						winhighlight = "Normal:Normal,FloatBorder:CmpBorder,CursorLine:CmpSel,Search:None",
					},
					documentation = false,
					-- documentation = {
					-- 	border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
					-- 	max_width = 25,
					-- 	max_height = 6,
					-- 	winhighlight = "Normal:CmpDoc,FloatBorder:CmpBorder",
					-- },
					-- 	scrollbar = false,
				},
				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = function(entry, vim_item)
						-- Modern Codicon-style icons
						local icons = {
							Text = "",
							Method = "󰆧",
							Function = "󰊕",
							Constructor = "",
							Field = "",
							Variable = "",
							Class = "",
							Interface = "",
							Module = "",
							Property = "",
							Unit = "",
							Value = "󰎠",
							Enum = "",
							Keyword = "",
							Snippet = "",
							Color = "",
							File = "",
							Reference = "",
							Folder = "",
							EnumMember = "",
							Constant = "󰏿",
							Struct = "",
							Event = "",
							Operator = "",
							TypeParameter = "",
						}

						-- Clean, compact kind formatting
						local icon = icons[vim_item.kind] or ""
						-- vim_item.kind = string.format("%s", icon)
						vim_item.kind = string.format("%s %s", icon, vim_item.kind) -- CLASS INTERFACE ...

						-- Source/module information with cleaner styling
						local source_names = {
							nvim_lsp = "",
							luasnip = "",
							path = "",
							buffer = "󰈚",
							nvim_lua = "",
						}

						local source_name = source_names[entry.source.name] or entry.source.name
						local module_name = ""

						-- Try different sources for module information
						if entry.completion_item then
							-- 1. Try LSP 3.17 labelDetails.description
							if
								entry.completion_item.labelDetails and entry.completion_item.labelDetails.description
							then
								module_name = entry.completion_item.labelDetails.description

							-- 2. Handle Python auto-import case
							elseif
								entry.completion_item.detail == "auto-import"
								and entry.completion_item.data
								and entry.completion_item.data.import
							then
								module_name = entry.completion_item.data.import:match("[%w_]+$") or ""

							-- 3. Fallback to detail field
							elseif entry.completion_item.detail then
								module_name = entry.completion_item.detail
							end
						end

						if module_name ~= "" then
							-- Show full package name with smart truncation
							if #module_name > 40 then
								-- Keep important beginning and end parts
								local start = module_name:sub(1, 15)
								local last_two = module_name:match("([^%.]+%.[^%.]+)$") or module_name:sub(-20)
								module_name = start .. "..." .. last_two
							end
							vim_item.menu = string.format("%s%s", source_name, module_name)
						else
							vim_item.menu = source_name
						end

						-- Trim long abbreviations for compact display
						if #vim_item.abbr > 30 then
							vim_item.abbr = vim_item.abbr:sub(1, 27) .. "…"
						end

						return vim_item
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
						elseif luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp", priority = 1000 },
					{ name = "luasnip", priority = 900 },
					{ name = "nvim_lua", priority = 800 },
					{ name = "buffer", priority = 500, keyword_length = 3 },
					{ name = "path", priority = 250 },
				}),
				performance = {
					throttle = 30, -- slightly faster for modern feel
					debounce = 30,
					fetching_timeout = 200,
				},
				experimental = {
					ghost_text = {
						hl_group = "Comment",
						-- More subtle ghost text
					},
				},
			})

			-- Command-line completion with same modern styling
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = { { name = "buffer" } },
				window = {
					completion = {
						border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
						winhighlight = "Normal:Normal,FloatBorder:CmpBorder,CursorLine:CmpSel",
					},
				},
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
				matching = { disallow_symbol_nonprefix_matching = false },
				window = {
					completion = {
						border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
						winhighlight = "Normal:Normal,FloatBorder:CmpBorder,CursorLine:CmpSel",
					},
				},
			})
		end,
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			check_ts = true,
			fast_wrap = { map = "<M-e>", offset = -1 },
			disable_filetype = { "TelescopePrompt", "spectre_panel" },
		},
		config = function(_, opts)
			require("nvim-autopairs").setup(opts)
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},
}
