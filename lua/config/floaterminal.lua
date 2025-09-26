local M = {}

M.open = function()
  -- Terminal size
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create buffer for floating terminal
  local bufnr = vim.api.nvim_create_buf(false, true) -- scratch buffer

  -- Floating window configuration
  local win = vim.api.nvim_open_win(bufnr, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    border = "rounded",
    style = "minimal",
    focusable = true,
  })

  -- Open PowerShell 7 in the terminal buffer
  local shell_cmd = "pwsh -NoLogo" -- PowerShell 7 command
  vim.fn.termopen(shell_cmd, {
    on_exit = function(_, exit_code, _)
      -- Close floating window automatically when terminal exits
      vim.api.nvim_win_close(win, true)
    end,
  })

  -- Make floating window use custom highlights
  vim.wo[win].winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder"

  -- Enter insert mode
  vim.cmd("startinsert")

  -- Map <Esc> in terminal to close floating window
  vim.keymap.set("t", "<Esc>", function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = bufnr })
end

return M
