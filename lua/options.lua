-- global status line
vim.opt.laststatus = 3

-- allow use of mouse
vim.opt.mouse = "a"

-- line numbering, relative
vim.opt.number = true
vim.wo.number = true
vim.wo.relativenumber = true

-- Highlights the results of previous search, which is annoying when we are done searching
vim.opt.hlsearch = false

-- Wrap lines in files
vim.opt.wrap = true

-- preseve indentation of virtual wrapped lines
vim.opt.breakindent = true

-- be smart with indents
vim.opt.smartindent = true

-- set tab length
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Dont use swap files, use undotree
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Search settings
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- split to the right or below always
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"
vim.diagnostic.config({
  float = { border = "single" },
})

-- Turn on new diff
vim.opt.diffopt:append("linematch:20")

-- Set screen mode
-- vim.o.noequalalways = true
-- vim.o.equalalways = false

-- enable colors for opacity changes
vim.o.termguicolors = true

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end


print("NIX FLAKE NVIM: nvim package count " .. dump(NVIM_PLUGIN_PATHS))
