function prereqs()
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

-- https://github.com/darold/pgFormatter

local rust_sqlx_f = function()
  return vim.treesitter.query.parse(
    "rust",
    [[
; query macro
(macro_invocation
   (scoped_identifier
     path: (identifier) @_path (#eq? @_path "sqlx")
     name: (identifier) @_name (#any-of? @_name "query" "query_scalar"))

 (token_tree
   . (raw_string_literal) @sql (#offset! @sql 1 0 -1 0))
 )

; query_as macro
(macro_invocation
   (scoped_identifier
     path: (identifier) @_path (#eq? @_path "sqlx")
     name: (identifier) @_name (#eq? @_name "query_as"))

 (token_tree
   (_) . (raw_string_literal) @sql (#offset! @sql 1 0 -1 0))

 )

; query and query_as function
(call_expression
  (scoped_identifier
    path: (identifier) @_path (#eq? @_path "sqlx")
    name: (identifier) @_name (#contains? @_name "query"))

 (arguments
   (raw_string_literal) @sql (#offset! @sql 1 0 -1 0))
  )
  ]]
  )
end

local get_root = function(bufnr)
  local parser = vim.treesitter.get_parser(bufnr, "rust", {})
  local tree = parser:parse()[1]
  return tree:root()
end

local format_dat_sql = function(bufnr)
  local rust_sqlx = rust_sqlx_f()
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  if vim.bo[bufnr].filetype ~= "rust" then
    vim.notify "can only be used in rust"
    return
  end

  local root = get_root(bufnr)

  local changes = {}
  for id, node in rust_sqlx:iter_captures(root, bufnr, 0, -1) do
    local name = rust_sqlx.captures[id]
    if name == "sql" then
      -- range: { row_start [1], col_start [2], row_end [3], col_end }
      local range = { node:range() }
      local indentation = string.rep(" ", range[2])

      local node_text = vim.treesitter.get_node_text(node, bufnr)
      if node_text:match('r#"\n(.*\n)+?%s*"#$') == nil then
        -- text is invalid because it does not have newlines in raw string literal
        goto continue
      end

      local text = node_text:sub(4, -3) -- get just the inside of the raw string literal
      -- TODO get current spaces for indentation and run pg_format with that indendation amount
      local formatted = vim.fn.system({ "pg_format", "-L" }, text)
      local lines = {}
      for line in formatted:gmatch("[^\r\n]+") do
        lines[#lines + 1] = line
      end

      for idx, line in ipairs(lines) do
        lines[idx] = indentation .. line
      end

      -- Fix indentation of end of raw string literal as well
      local last_line = vim.api.nvim_buf_get_lines(bufnr, range[3], range[3] + 1, true)[1]:match("^%s*(.*)")
      -- print("LAST LINE", last_line)
      lines[#lines + 1] = indentation .. last_line

      table.insert(changes, 1, {
        start = range[1] + 1,
        final = range[3] + 1,
        formatted = lines,
      })

      -- changes[#changes + 1] = {
      --   col = 0,
      --   row = range[1] + 2,
      --   end_col = -1,
      --   end_row = range[3] + 1,
      --   text = table.concat(lines, '\n'),
      -- }

      ::continue::
    end
  end

  -- return changes

  print("Change", vim.inspect(changes))
  for _, change in ipairs(changes) do
    vim.api.nvim_buf_set_lines(bufnr, change.start, change.final, false, change.formatted)
  end
end

vim.api.nvim_create_user_command("SqlMagic", function()
  format_dat_sql()
end, {})

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
      -- ╰─ cat src/main.rs| rustfmt --emit=stdout --edition=2021 --color=never
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
        rust_formatter_genemichaels,          -- order matters, we run genemichaels first then rustfmt
        rust_formatter_rustfmt,
        rust_formatter_sqlx,
        null_ls.builtins.formatting.black, -- python
        -- null_ls.builtins.code_actions.proselint, -- TODO looks interesting
        null_ls.builtins.code_actions.cspell.with({
          config = {
            find_json = function()
              return vim.fn.findfile("cspell.json", vim.fn.environ().HOME .. "/.config/nvim/lua/user/;")
            end,
          },
        }),
        null_ls.builtins.diagnostics.cspell.with({
          extra_args = { "--config", "~/.config/nvim/lua/user/cspell.json" },
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
