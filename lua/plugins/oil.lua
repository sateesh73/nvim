return {
  'stevearc/oil.nvim',
  main = "oil",
  opts = {
    default_file_explorer = true, -- Replace NetRW
    delete_to_trash = true,       -- Move deleted files to trash
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true,
      natural_order = true,
      is_always_hidden = function(name, bufnr)
        return name == ".." or name == ".git"
      end,
    },
    win_options = {
      wrap = true,
    },
  },
  lazy = false,
  priority = 900,
}
