-- Function to remove item from quickfix list
local function RemoveQFItem()
  local currentIndex = vim.fn.line(".") - 1
  local quickfixList = vim.fn.getqflist()
  -- Remove current item and replace the quickfix list
  table.remove(quickfixList, currentIndex + 1) -- Lua is 1-indexed
  vim.fn.setqflist(quickfixList, "r")
  -- Keep cursor on the line it was +1 (so it goes to next item rather than back up)
  vim.cmd("cwindow | :" .. (currentIndex + 1))
end

-- Command to call the function
vim.api.nvim_create_user_command("RemoveQFItem", RemoveQFItem, {})

-- Auto command to map 'dd' in quickfix window
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("myconfig-quick-fix-group", { clear = true }),
  pattern = "qf",
  callback = function(event)
    vim.keymap.set("n", "dd", RemoveQFItem, { buffer = event.buffer, silent = true })
  end,
})
