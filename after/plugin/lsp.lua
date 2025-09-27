vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		vim.opt.tabstop = 2
		vim.opt.shiftwidth = 2
		vim.opt.softtabstop = 2
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client == nil then
			return
		end
		-- Disable semantic highlights
		client.server_capabilities.semanticTokensProvider = nil

		local opts = { buffer = event.buf }
		local builtin = require("telescope.builtin")

		vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gd", builtin.lsp_definitions, opts)
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gi", builtin.lsp_implementations, opts)
		vim.keymap.set("n", "gr", builtin.lsp_references, opts)
		vim.keymap.set("n", "gs", builtin.lsp_workspace_symbols, opts)
		vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "x" }, "=", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
		vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "g]", "<cmd>lua vim.diagnostic.jump({count=1, float=true})<cr>", opts)
		vim.keymap.set("n", "g[", "<cmd>lua vim.diagnostic.jump({count=-1, float=true})<cr>", opts)
	end,
})

vim.lsp.config("ts_ls", {
	on_attach = function(client)
		vim.opt.tabstop = 2
		vim.opt.shiftwidth = 2
		vim.opt.softtabstop = 2
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "java",
	callback = function(args)
		require("jdtls.jdtls_setup").setup()
	end,
})

vim.diagnostic.config({
	virtual_text = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "ErrorMsg",
			[vim.diagnostic.severity.WARN] = "WarningMsg",
		},
	},
})

-- Reusable function to display content in a floating window

local function show_floating_window(lines, title)
	local bufnr = vim.api.nvim_create_buf(false, true)

	-- buffer options (keep modifiable until we finish writing)
	vim.bo[bufnr].bufhidden = "wipe"
	vim.bo[bufnr].buftype = "nofile"
	vim.bo[bufnr].swapfile = false
	vim.bo[bufnr].modifiable = true

	-- If title provided, insert placeholders to be replaced after width calculation
	if title then
		table.insert(lines, 1, "") -- spacer (we will replace)
		table.insert(lines, 1, "TITLE_PLACEHOLDER")
		table.insert(lines, 1, "") -- top divider placeholder
	end

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

	-- compute size
	local max_line_len = 0
	for _, line in ipairs(lines) do
		max_line_len = math.max(max_line_len, vim.fn.strwidth(line))
	end
	local width = math.min(vim.o.columns - 8, max_line_len + 4)
	local height = math.min(vim.o.lines - 8, #lines)

	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	-- If title: build divider and centered title and replace the first 3 lines
	if title then
		local divider = ("═"):rep(width)
		local padded = " " .. title .. " "
		if vim.fn.strwidth(padded) > width then
			padded = padded:sub(1, width)
		end
		local left = math.floor((width - vim.fn.strwidth(padded)) / 2)
		local right = math.max(0, width - left - vim.fn.strwidth(padded))
		local title_line = string.rep(" ", left) .. padded .. string.rep(" ", right)
		-- replace top 3 lines
		vim.api.nvim_buf_set_lines(bufnr, 0, 3, false, { divider, title_line, divider })
	end

	-- make buffer read-only now
	vim.bo[bufnr].modifiable = false

	-- open window
	local win = vim.api.nvim_open_win(bufnr, true, {
		relative = "editor",
		row = row,
		col = col,
		width = width,
		height = height,
		border = "rounded",
		style = "minimal",
		focusable = true,
		noautocmd = true,
	})

	-- apply window-local highlight mapping to use our linked groups
	-- Normal -> MyFloatNormal, FloatBorder -> MyFloatBorder
	vim.wo[win].winhighlight = "Normal:MyFloatNormal,FloatBorder:MyFloatBorder"

	-- close with <Esc>
	vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", {
		buffer = bufnr,
		silent = true,
		nowait = true,
		desc = "Close floating window",
	})

	vim.keymap.set("n", "q", "<cmd>close<CR>", {
		buffer = bufnr,
		silent = true,
		nowait = true,
		desc = "Close floating window",
	})
	-- optionally set winblend, if you want semi-transparency:
	vim.wo[win].winblend = 0
end

local function capture_print_output(func)
	local old_print = print
	local captured_lines = {}

	-- Temporarily redefine print to capture output
	_G.print = function(...)
		local items = {}
		for i = 1, select("#", ...) do
			table.insert(items, tostring(select(i, ...)))
		end
		table.insert(captured_lines, table.concat(items, "\t")) -- Join items with a tab, similar to default print behavior
	end

	-- Execute the function whose output we want to capture
	func()

	-- Restore the original print function
	_G.print = old_print

	return captured_lines
end

local function restart_lsp(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })

	for _, client in ipairs(clients) do
		vim.lsp.stop_client(client.id)
	end

	vim.defer_fn(function()
		vim.cmd("edit")
	end, 100)
end

vim.api.nvim_create_user_command("LspRestart", function()
	restart_lsp()
end, {})

local function lsp_status()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })

	if #clients == 0 then
		print("󰅚 No LSP clients attached")
		return
	end

	print("󰒋 LSP Status for buffer " .. bufnr .. ":")
	print("─────────────────────────────────")

	for i, client in ipairs(clients) do
		print(string.format("󰌘 Client %d: %s (ID: %d)", i, client.name, client.id))
		print("  Root: " .. (client.config.root_dir or "N/A"))
		print("  Filetypes: " .. table.concat(client.config.filetypes or {}, ", "))

		-- Check capabilities
		local caps = client.server_capabilities
		local features = {}
		if caps.completionProvider then
			table.insert(features, "completion")
		end
		if caps.hoverProvider then
			table.insert(features, "hover")
		end
		if caps.definitionProvider then
			table.insert(features, "definition")
		end
		if caps.referencesProvider then
			table.insert(features, "references")
		end
		if caps.renameProvider then
			table.insert(features, "rename")
		end
		if caps.codeActionProvider then
			table.insert(features, "code_action")
		end
		if caps.documentFormattingProvider then
			table.insert(features, "formatting")
		end

		print("  Features: " .. table.concat(features, ", "))
		print("")
	end
end

local function lsp_status_float_wrapper()
	local captured_lines = capture_print_output(lsp_status)
	show_floating_window(captured_lines, "LSP Status")
end
vim.api.nvim_create_user_command("LspStatus", lsp_status_float_wrapper, { desc = "Show detailed LSP status" })

local function check_lsp_capabilities()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })

	if #clients == 0 then
		print("No LSP clients attached")
		return
	end

	for _, client in ipairs(clients) do
		print("Capabilities for " .. client.name .. ":")
		local caps = client.server_capabilities

		local capability_list = {
			{ "Completion", caps.completionProvider },
			{ "Hover", caps.hoverProvider },
			{ "Signature Help", caps.signatureHelpProvider },
			{ "Go to Definition", caps.definitionProvider },
			{ "Go to Declaration", caps.declarationProvider },
			{ "Go to Implementation", caps.implementationProvider },
			{ "Go to Type Definition", caps.typeDefinitionProvider },
			{ "Find References", caps.referencesProvider },
			{ "Document Highlight", caps.documentHighlightProvider },
			{ "Document Symbol", caps.documentSymbolProvider },
			{ "Workspace Symbol", caps.workspaceSymbolProvider },
			{ "Code Action", caps.codeActionProvider },
			{ "Code Lens", caps.codeLensProvider },
			{ "Document Formatting", caps.documentFormattingProvider },
			{ "Document Range Formatting", caps.documentRangeFormattingProvider },
			{ "Rename", caps.renameProvider },
			{ "Folding Range", caps.foldingRangeProvider },
			{ "Selection Range", caps.selectionRangeProvider },
		}

		for _, cap in ipairs(capability_list) do
			local status = cap[2] and "✓" or "✗"
			print(string.format("  %s %s", status, cap[1]))
		end
		print("")
	end
end

local function cap()
	local captured_lines = capture_print_output(check_lsp_capabilities)
	show_floating_window(captured_lines, "LSP Capabilities")
end
vim.api.nvim_create_user_command("LspCapabilities", cap, { desc = "Show LSP capabilities" })

local function lsp_diagnostics_info()
	local bufnr = vim.api.nvim_get_current_buf()
	local diagnostics = vim.diagnostic.get(bufnr)

	local counts = { ERROR = 0, WARN = 0, INFO = 0, HINT = 0 }

	for _, diagnostic in ipairs(diagnostics) do
		local severity = vim.diagnostic.severity[diagnostic.severity]
		counts[severity] = counts[severity] + 1
	end

	print("󰒡 Diagnostics for current buffer:")
	print("  Errors: " .. counts.ERROR)
	print("  Warnings: " .. counts.WARN)
	print("  Info: " .. counts.INFO)
	print("  Hints: " .. counts.HINT)
	print("  Total: " .. #diagnostics)
end

local function diagnostics()
	local captured_lines = capture_print_output(lsp_diagnostics_info)
	show_floating_window(captured_lines, "LSP Diagnostics")
end
vim.api.nvim_create_user_command("LspDiagnostics", diagnostics, { desc = "Show LSP diagnostics count" })

local function lsp_info()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })

	-- Basic info
	print("󰈙 Language client log: " .. vim.lsp.get_log_path())
	print("󰈔 Detected filetype: " .. vim.bo.filetype)
	print("󰈮 Buffer: " .. bufnr)
	print("󰈔 Root directory: " .. (vim.fn.getcwd() or "N/A"))
	print("")

	if #clients == 0 then
		print("󰅚 No LSP clients attached to buffer " .. bufnr)
		print("")
		print("Possible reasons:")
		print("  • No language server installed for " .. vim.bo.filetype)
		print("  • Language server not configured")
		print("  • Not in a project root directory")
		print("  • File type not recognized")
		return
	end

	print("󰒋 LSP clients attached to buffer " .. bufnr .. ":")
	print("─────────────────────────────────")

	for i, client in ipairs(clients) do
		print(string.format("󰌘 Client %d: %s", i, client.name))
		print("  ID: " .. client.id)
		print("  Root dir: " .. (client.config.root_dir or "Not set"))
		print("  Command: " .. table.concat(client.config.cmd or {}, " "))
		print("  Filetypes: " .. table.concat(client.config.filetypes or {}, ", "))

		-- Server status
		if client.is_stopped() then
			print("  Status: 󰅚 Stopped")
		else
			print("  Status: 󰄬 Running")
		end

		-- Workspace folders
		if client.workspace_folders and #client.workspace_folders > 0 then
			print("  Workspace folders:")
			for _, folder in ipairs(client.workspace_folders) do
				print("    • " .. folder.name)
			end
		end

		-- Attached buffers count
		local attached_buffers = {}
		for buf, _ in pairs(client.attached_buffers or {}) do
			table.insert(attached_buffers, buf)
		end
		print("  Attached buffers: " .. #attached_buffers)

		-- Key capabilities
		local caps = client.server_capabilities
		local key_features = {}
		if caps.completionProvider then
			table.insert(key_features, "completion")
		end
		if caps.hoverProvider then
			table.insert(key_features, "hover")
		end
		if caps.definitionProvider then
			table.insert(key_features, "definition")
		end
		if caps.documentFormattingProvider then
			table.insert(key_features, "formatting")
		end
		if caps.codeActionProvider then
			table.insert(key_features, "code_action")
		end

		if #key_features > 0 then
			print("  Key features: " .. table.concat(key_features, ", "))
		end

		print("")
	end

	-- Diagnostics summary
	local diagnostics = vim.diagnostic.get(bufnr)
	if #diagnostics > 0 then
		print("󰒡 Diagnostics Summary:")
		local counts = { ERROR = 0, WARN = 0, INFO = 0, HINT = 0 }

		for _, diagnostic in ipairs(diagnostics) do
			local severity = vim.diagnostic.severity[diagnostic.severity]
			counts[severity] = counts[severity] + 1
		end

		print("  󰅚 Errors: " .. counts.ERROR)
		print("  󰀪 Warnings: " .. counts.WARN)
		print("  󰋽 Info: " .. counts.INFO)
		print("  󰌶 Hints: " .. counts.HINT)
		print("  Total: " .. #diagnostics)
	else
		print("󰄬 No diagnostics")
	end

	print("")
	print("Use :LspLog to view detailed logs")
	print("Use :LspCapabilities for full capability list")
end

-- Wrapper function to capture output and show in float
local function lsp_info_float_wrapper()
	local captured_lines = capture_print_output(lsp_info)
	show_floating_window(captured_lines, "LSP INFORMATION")
end
-- Create command
vim.api.nvim_create_user_command("LspInfo", lsp_info_float_wrapper, { desc = "Show comprehensive LSP information" })

local function lsp_status_short()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })

	if #clients == 0 then
		return "" -- Return empty string when no LSP
	end

	local names = {}
	for _, client in ipairs(clients) do
		table.insert(names, client.name)
	end

	return "󰒋 " .. table.concat(names, ",")
end

local function git_branch()
	local ok, handle = pcall(io.popen, "git branch --show-current 2>/dev/null")
	if not ok or not handle then
		return ""
	end
	local branch = handle:read("*a")
	handle:close()
	if branch and branch ~= "" then
		branch = branch:gsub("\n", "")
		return " 󰊢 " .. branch
	end
	return ""
end

local function formatter_status()
	local ok, conform = pcall(require, "conform")
	if not ok then
		return ""
	end

	local formatters = conform.list_formatters_to_run(0)
	if #formatters == 0 then
		return ""
	end

	local formatter_names = {}
	for _, formatter in ipairs(formatters) do
		table.insert(formatter_names, formatter.name)
	end

	return "󰉿 " .. table.concat(formatter_names, ",")
end

local function linter_status()
	local ok, lint = pcall(require, "lint")
	if not ok then
		return ""
	end

	local linters = lint.linters_by_ft[vim.bo.filetype] or {}
	if #linters == 0 then
		return ""
	end

	return "󰁨 " .. table.concat(linters, ",")
end
-- Safe wrapper functions for statusline
local function safe_git_branch()
	local ok, result = pcall(git_branch)
	return ok and result or ""
end

local function safe_lsp_status()
	local ok, result = pcall(lsp_status_short)
	return ok and result or ""
end

local function safe_formatter_status()
	local ok, result = pcall(formatter_status)
	return ok and result or ""
end

local function safe_linter_status()
	local ok, result = pcall(linter_status)
	return ok and result or ""
end

_G.git_branch = safe_git_branch
_G.lsp_status = safe_lsp_status
_G.formatter_status = safe_formatter_status
_G.linter_status = safe_linter_status

-- THEN set the statusline
vim.opt.statusline = table.concat({
	"%{v:lua.git_branch()}", -- Git branch
	"%f", -- File name
	"%m", -- Modified flag
	"%r", -- Readonly flag
	"%=", -- Right align
	"%{v:lua.linter_status()}", -- Linter status
	"%{v:lua.formatter_status()}", -- Formatter status
	"%{v:lua.lsp_status()}", -- LSP status
	" %l:%c", -- Line:Column
	" %p%%", -- Percentage through file
}, " ")
