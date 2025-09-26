return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {
        "      ███╗   ██╗ ███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
        "      ████╗  ██║ ██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
        "      ██╔██╗ ██║ █████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
        "      ██║╚██╗██║ ██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
        "      ██║ ╚████║ ███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
        "      ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
      }

      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file", "<cmd>Telescope find_files<cr>"),
        dashboard.button("r", "  Recent", "<cmd>Telescope oldfiles<cr>"),
        dashboard.button("g", "  Find text", "<cmd>Telescope live_grep<cr>"),
        dashboard.button("c", "  Config",
          string.format("<cmd>Telescope find_files cwd=%s<cr>", vim.fn.stdpath("config"))),
        dashboard.button("q", "  Quit", "<cmd>qa<cr>"),
      }

      return dashboard
    end,
    config = function(_, dashboard)
      require("alpha").setup(dashboard.opts)
    end,
  },
}
