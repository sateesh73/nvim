return {
  "folke/which-key.nvim",
  event = "VimEnter",
  config = function()
    local which_key = require("which-key")
    which_key.setup()

    which_key.add({
      { "<leader>/", group = "Comments" },
      { "<leader>c", group = "Code" },
      { "<leader>d", group = "Debug" },
      { "<leader>e", group = "Explorer" },
      { "<leader>f", group = "Find" },
      { "<leader>g", group = "Git" },
      { "<leader>J", group = "Java" },
      { "<leader>t", group = "Tab" },
      { "<leader>w", group = "Window" },
    })
  end,
}

