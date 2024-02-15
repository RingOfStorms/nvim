-- Function to remove item from quickfix list
function RemoveQFItem()
  local curqfidx = vim.fn.line(".") - 1
  local qfall = vim.fn.getqflist()
  table.remove(qfall, curqfidx + 1) -- Lua is 1-indexed
  vim.fn.setqflist(qfall, "r")
  vim.cmd(curqfidx .. "cfirst")
  vim.cmd("copen")
end

-- Command to call the function
vim.api.nvim_create_user_command("RemoveQFItem", RemoveQFItem, {})

-- Auto command to map 'dd' in quickfix window
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "dd", RemoveQFItem, { buffer = true, silent = true })
  end,
})
