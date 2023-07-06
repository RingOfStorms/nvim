local function lsp_clients()
  local clients = {}
  for _, client in pairs(vim.lsp.buf_get_clients(0)) do
    clients[#clients + 1] = client.name
  end

  table.sort(clients)
  return table.concat(clients, " • "), " "
end

local function langs()
  local langs = {}
  for _, client in pairs(vim.lsp.buf_get_clients(0)) do
    local out = nil
    if client.name == "pyright" then
      out = vim.fn.system({ "python", "-V" })
    elseif client.name == "tsserver" then
      out = 'node ' .. vim.fn.system({ "node", "--version" })
    end
    if out ~= nil and out ~= "" then
      langs[#langs + 1] = vim.trim(out)
    end
  end

  table.sort(langs)
  return table.concat(langs, " • "), " "
end

return {
  "nvim-lualine/lualine.nvim",
  opts = {
    options = {
      theme = "codedark",
      section_separators = { left = "", right = "" },
      component_separators = "|",
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = { "filename" },
      lualine_x = { lsp_clients, langs, "encoding", "filetype", "filesize" },
      lualine_y = { "searchcount", "selectioncount" },
      lualine_z = { "location" },
    },
    refresh = {
      statusline = 200,
    },
    winbar = {
      lualine_a = {
        {
          "filename",
          symbols = {
            modified = "", -- Text to show when the file is modified.
            readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
            unnamed = "[No Name]", -- Text to show for unnamed buffers.
            newfile = "[New]", -- Text to show for newly created file before first write
          },
        },
      },
      lualine_b = {
        "mode"
      }
    },
    inactive_winbar = {
      lualine_a = {
        {
          "filename",
          symbols = {
            modified = "", -- Text to show when the file is modified.
            readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
            unnamed = "[No Name]", -- Text to show for unnamed buffers.
            newfile = "[New]", -- Text to show for newly created file before first write
          },
        },
      },
    },
  },
}
