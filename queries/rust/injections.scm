; ==== SQLX syntax highlighting
; query macro
(macro_invocation
   (scoped_identifier
     path: (identifier) @_path (#eq? @_path "sqlx")
     name: (identifier) @_name (#any-of? @_name "query" "query_scalar"))

 (token_tree
   ; . [(raw_string_literal) @sql (string_literal) @sql])
   . (raw_string_literal) @sql (#offset! @sql 1 0 -1 0))
 )

; query_as macro
(macro_invocation
   (scoped_identifier
     path: (identifier) @_path (#eq? @_path "sqlx")
     name: (identifier) @_name (#eq? @_name "query_as"))

 (token_tree
   ; (_) . [(raw_string_literal) @sql (string_literal) @sql])
   (_) . (raw_string_literal) @sql (#offset! @sql 1 0 -1 0))
   
 )

; query and query_as function
(call_expression
  (scoped_identifier
    path: (identifier) @_path (#eq? @_path "sqlx")
    name: (identifier) @_name (#contains? @_name "query"))

 (arguments
   ; [(raw_string_literal) @sql  (string_literal) @sql])
   (raw_string_literal) @sql (#offset! @sql 1 0 -1 0))
  )

