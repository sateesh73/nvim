return {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    opts = function()
        vim.g.gruvbox_material_enable_italic = true
        vim.g.gruvbox_material_transparent_background = 1
        vim.g.gruvbox_material_foreground = "mix"
        vim.g.gruvbox_material_background = "hard"
        vim.g.gruvbox_material_ui_contrast = "high"
        vim.g.gruvbox_material_float_style = "bright"
        vim.g.gruvbox_material_statusline_style = "mix" -- Options: "original", "material", "mix", "afterglow"
        vim.g.gruvbox_material_cursor = "auto"
        vim.cmd.colorscheme('gruvbox-material')
    end
}
