return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
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
            java = { "google_java_format" }, -- This line specifies the formatter for Java
        },
    },
}
