return {
  "Pocco81/auto-save.nvim",
  event = "BufEnter",
  init = function()
    vim.notify("test")
  end,
  opts = {
    trigger_events = { "InsertLeave", "TextChanged", "TextChangedI", "BufLeave" },
    condition = function(buf)
      local disallowed_filetypes = { "TelescopePrompt" }
      local utils = require("auto-save.utils.data")
      if
        vim.fn.getbufvar(buf, "&modifiable") == 1
        and utils.not_in(vim.fn.getbufvar(buf, "&filetype"), disallowed_filetypes)
      then
        return true
      end
      return false
    end,
  },
}
