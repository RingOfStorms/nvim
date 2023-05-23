-- npm install -g cspell@latest

local output = vim.fn.system {
  "which",
  "cspell",
}
if output == nil or output == "" then
  -- if v:shell_error != 0 then
  vim.fn.system {
    "npm",
    "install",
    "-g",
    "cspell@latest",
  }
end

return {
  "jose-elias-alvarez/null-ls.nvim",
	commit = "77e53bc3bac34cc273be8ed9eb9ab78bcf67fa48",
  opts = function(_, config)
    -- config variable is the default definitions table for the setup function call
    local null_ls = require "null-ls"

    -- Check supported formatters and linters
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    config.sources = {
      -- Set a formatter
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.prettier,
      null_ls.builtins.formatting.rustfmt,
      -- null_ls.builtins.code_actions.proselint, -- TODO looks interesting
      null_ls.builtins.code_actions.cspell.with {
        config = {
          find_json = function() return vim.fn.findfile("cspell.json", vim.fn.environ().HOME .. "/.config/nvim/lua/user/;") end,
        },
      },
      null_ls.builtins.diagnostics.cspell.with {
        extra_args = { "--config", "~/.config/nvim/lua/user/cspell.json" },
      },
    }

    config.update_in_insert = true

    return config -- return final config table
  end,
}
