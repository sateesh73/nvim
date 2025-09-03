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

      -- Force transparency
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
      vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
    end,
  },
}

