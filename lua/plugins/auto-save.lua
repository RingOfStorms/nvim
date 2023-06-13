return {
  "Pocco81/auto-save.nvim",
	commit = "979b6c82f60cfa80f4cf437d77446d0ded0addf0", -- May 22, 2023
  event = "BufEnter",
  opts = {
    trigger_events = { "InsertLeave", "TextChanged", "TextChangedI", "BufLeave" },
    condition = function (buf)
      local disallowed_filetypes = {"TelescopePrompt"}
      local utils = require('auto-save.utils.data')
      if vim.fn.getbufvar(buf, "&modifiable") == 1 and utils.not_in(vim.fn.getbufvar(buf, "&filetype"), disallowed_filetypes) then
        return true
      end
      return false
    end
  }
}
