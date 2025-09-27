local M = {}

M.open_term = function()
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
    border = "none",
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

-- Define custom highlight groups
-- vim.api.nvim_set_hl(0, "MyFloat", { bg = "#1d2021", fg = "#ebdbb2" }) -- Gruvbox dark hard bg
vim.api.nvim_set_hl(0, "MyFloat", {
    bg = vim.api.nvim_get_hl_by_name("NormalFloat", true).background,
    fg = vim.api.nvim_get_hl_by_name("NormalFloat", true).foreground,
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
-- Get line numbers for highlighted lines in visual mode
M.get_highlighted_line_numbers = function()
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")

  if start_line == 0 or end_line == 0 then
    print("No visual selection found")
    return
  end

  -- Ensure start_line is always less than or equal to end_line
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  local line_numbers = {}
  for i = start_line, end_line do
    table.insert(line_numbers, i)
  end

  local result
  if start_line == end_line then
    -- Single line: L80
    result = string.format("L%d", start_line)
  else
    -- Multiple lines: L80-85
    result = string.format("L%d-%d", start_line, end_line)
  end

  print("Line numbers: " .. result)

  -- Copy to clipboard
  vim.fn.setreg("+", result)

  return line_numbers
end
return M
