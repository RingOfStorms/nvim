vim.opt.list = true
-- vim.opt.listchars = ''
-- vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"
vim.opt.listchars:append "tab: >"

local highlight = require('util').highlight
-- Dull Version
highlight("IndentBlanklineIndent1", { fg = "#915053", gui="nocombine" })
highlight("IndentBlanklineIndent2", { fg = "#A27F3E", gui="nocombine" })
highlight("IndentBlanklineIndent3", { fg = "#6B7F6E", gui="nocombine" })
highlight("IndentBlanklineIndent4", { fg = "#5A747D", gui="nocombine" })
highlight("IndentBlanklineIndent5", { fg = "#6B6282", gui="nocombine" })

-- highlight("SpecialKey", { fg = "#fff", gui = "nocombine" })
-- highlight("Whitespace", { fg = "#fff", gui = "nocombine" })
highlight("NonText", { fg = "#303030", gui = "nocombine" })

return {
  -- Add indentation guides even on blank lines
  "lukas-reineke/indent-blankline.nvim",
  -- Enable `lukas-reineke/indent-blankline.nvim`
  -- See `:help indent_blankline.txt`
  opts = {
    -- space_char_blankline = " ",
    -- indent_blankline_space_char_blankline = "=",
    -- char = '┊',
    -- char = '.',
    -- char = '¦',
    use_treesitter = true,
    char_highlight_list = {
      "IndentBlanklineIndent1",
      "IndentBlanklineIndent2",
      "IndentBlanklineIndent3",
      "IndentBlanklineIndent4",
      "IndentBlanklineIndent5",
    },
  
        
				    

    

  },
}
