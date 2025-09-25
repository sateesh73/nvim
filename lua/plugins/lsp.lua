-- lua/plugins/lsp.lua
return {
  "elmcgill/springboot-nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-jdtls",
    "nvim-tree/nvim-tree.lua",
    "mfussenegger/nvim-dap",
    "rcarriga/nvim-dap-ui",
  },
  config = function()
    -- --------------------------
    -- Spring Boot setup
    -- --------------------------
    local ok_sb, springboot_nvim = pcall(require, "springboot-nvim")
    if ok_sb then
      springboot_nvim.setup({})
    end

    -- --------------------------
    -- Hover border
    -- --------------------------
    vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
      if not (result and result.contents) then
        return
      end

      local border = {
        { "╭", "GruvboxOrange" },
        { "─", "GruvboxOrange" },
        { "╮", "GruvboxOrange" },
        { "│", "GruvboxOrange" },
        { "╯", "GruvboxOrange" },
        { "─", "GruvboxOrange" },
        { "╰", "GruvboxOrange" },
        { "│", "GruvboxOrange" },
      }

      config = config or {}
      config = vim.tbl_extend("force", {
        border = border,
        max_width = 80,
        max_height = 20,
        focus_id = ctx.method,
        zindex = 50,
      }, config)

      -- Convert hover content to markdown lines
      local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)

      -- Modern replacement for trim_empty_lines
      markdown_lines = vim.tbl_filter(function(line)
        return line:match("%S") -- keep only non-empty lines
      end, markdown_lines)

      if vim.tbl_isempty(markdown_lines) then
        return
      end

      -- Add optional info: Symbol kind and file name
      local symbol_kind = result.symbolKind and ("**Kind:** " .. result.symbolKind) or ""
      local filename = vim.api.nvim_buf_get_name(ctx.bufnr)
      table.insert(markdown_lines, 1, "") -- space below title
      table.insert(markdown_lines, 1, "**File:** " .. filename)
      if symbol_kind ~= "" then
        table.insert(markdown_lines, 1, symbol_kind)
      end
      table.insert(markdown_lines, 1, "**Hover Info**") -- Title

      -- Open the floating preview
      return vim.lsp.util.open_floating_preview(markdown_lines, "markdown", config)
    end
    -- --------------------------
    -- Java LSP + DAP (JDTLS)
    -- --------------------------
  end,
}
