--PREREQ: https://github.com/darold/pgFormatter

-- Based on this video: https://www.youtube.com/watch?v=v3o9YaHBM4Q

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

      -- Some left overs from me attempting to get this to work inside of a null_ls formatter
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

  -- print("Change", vim.inspect(changes))
  for _, change in ipairs(changes) do
    vim.api.nvim_buf_set_lines(bufnr, change.start, change.final, false, change.formatted)
  end
end

vim.api.nvim_create_user_command("SqlxFormat", function()
  format_dat_sql()
end, {})
