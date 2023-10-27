local function prereqs()
  local output_cspell = vim.fn.system({
    "which",
    "cspell",
  })
  if output_cspell == nil or output_cspell == "" or output_cspell == "cspell not found" then
    print("Installing cspell globally with npm")
    vim.fn.system({
      "npm",
      "install",
      "-g",
      "cspell",
    })
  end
end

return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "williamboman/mason.nvim" },
    build = prereqs,
    opts = function(_, config)
      -- config variable is the default definitions table for the setup function call
      local null_ls = require("null-ls")

      -- Custom rust formatter: genemichaels first, then rustfmt, nightly if experimental
      local rust_formatter_genemichaels = {
        name = "rust_formatter_genemichaels",
        method = null_ls.methods.FORMATTING,
        filetypes = { "rust" },
        generator = null_ls.formatter({
          command = "genemichaels",
          args = { '-q' },
          to_stdin = true,
        }),
      }
      -- $ cat src/main.rs| rustfmt --emit=stdout --edition=2021 --color=never
      local rust_formatter_rustfmt = {
        name = "rust_formatter_rustfmt",
        method = null_ls.methods.FORMATTING,
        filetypes = { "rust" },
        generator = null_ls.formatter({
          command = "rustfmt",
          args = { '--emit=stdout', "--edition=$(grep edition Cargo.toml | awk '{print substr($3,2,length($3)-2)}')",
            '--color=never' },
          to_stdin = true,
        }),
      }

      -- local rust_formatter_sqlx = {
      --   name = "rust_formatter_sqlx",
      --   method = null_ls.methods.FORMATTING,
      --   filetypes = { "rust" },
      --   generator = {
      --     fn = function(params)
      --       local changes = format_dat_sql(params.bufnr)
      --       -- print("CHANGES:\n", vim.inspect(changes))
      --       -- return changes
      --     end
      --   },
      -- }

      null_ls.register(rust_formatter_genemichaels)
      null_ls.register(rust_formatter_rustfmt)
      -- null_ls.register(rust_formatter_sqlx)

      -- Check supported formatters and linters
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
      config.sources = {
        null_ls.builtins.formatting.prettier, -- typescript/javascript
        null_ls.builtins.formatting.stylua,   -- lua
        --null_ls.builtins.formatting.rustfmt, -- rust
        rust_formatter_genemichaels,          -- order matters, run genemichaels first then rustfmt
        rust_formatter_rustfmt,
        -- rust_formatter_sqlx, -- see tools/sqlx-format.lua
        null_ls.builtins.formatting.black, -- python
        -- null_ls.builtins.code_actions.proselint, -- TODO looks interesting
        null_ls.builtins.code_actions.cspell.with({
          config = {
            find_json = function()
              return vim.fn.findfile("cspell.json", vim.fn.environ().HOME .. "/.config/nvim/;")
            end,
          },
        }),
        null_ls.builtins.diagnostics.cspell.with({
          extra_args = { "--config", "~/.config/nvim/cspell.json" },
        }),
      }

      config.update_in_insert = true
      config.debug = true

      return config
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    opts = {
      ensure_installed = { "rustfmt", "stylelua", "prettier", "black" },
    },
  },
}
