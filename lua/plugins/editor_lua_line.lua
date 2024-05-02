-- TODO checkout https://github.com/nvim-lua/lsp-status.nvim
-- https://www.reddit.com/r/neovim/comments/o4bguk/comment/h2kcjxa/
local function lsp_clients()
  local clients = {}
  for _, client in pairs(vim.lsp.buf_get_clients(0)) do
    local name = client.name
    -- TODO revisit this doesn't work
    if not client.initialized then
      name = name .. " (loading)"
    end
    clients[#clients + 1] = name
  end

  table.sort(clients)
  return table.concat(clients, " • "), " "
end

local function langs()
  local l = {}
  for _, client in pairs(vim.lsp.buf_get_clients(0)) do
    local out = nil
    if client.name == "pyright" then
      out = vim.fn.system({ "python", "-V" })
    elseif client.name == "tsserver" then
      out = "node " .. vim.fn.system({ "node", "--version" })
    end
    if out ~= nil and out ~= "" then
      l[#l + 1] = vim.trim(out)
    end
  end

  table.sort(l)
  return table.concat(l, " • "), " "
end

local last_blame = nil
local last_blame_time = vim.loop.now()
local function gitblame()
  local d = vim.b.gitsigns_blame_line_dict

  if d then
    last_blame = d
    last_blame_time = vim.loop.now()
  elseif vim.loop.now() - last_blame_time <= 2000 then
    d = last_blame
  end

  if d then
    local ok, res = pcall(os.date, "%d %b %y", d.committer_time)
    return d.committer .. " - " .. (ok and res or d.committer_time)
  end
  return ""
end

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { { "folke/noice.nvim", optional = true } },
  lazy = false,
  opts = function()
    return {
      options = {
        theme = "codedark",
        section_separators = { left = "", right = "" },
        component_separators = "|",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {
          { "filename", separator = { right = "" } },
          { "reg_recording", icon = { "󰻃" }, color = { fg = "#D37676" } },
          { gitblame, color = { fg = "#696969" } },
        },
        lualine_x = {
          lsp_clients,
          langs,
          "encoding",
          "filetype",
          "filesize",
        },
        lualine_y = { "searchcount", "selectioncount" },
        lualine_z = { "location" },
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
          "mode",
        },
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
    }
  end,
  config = function(_, opts)
    require("lualine").setup(opts)

    local ref = function()
      require("lualine").refresh({
        place = { "statusline" },
      })
    end

    vim.api.nvim_create_autocmd("RecordingEnter", {
      callback = ref,
    })

    vim.api.nvim_create_autocmd("RecordingLeave", {
      callback = function()
        local timer = vim.loop.new_timer()
        timer:start(50, 0, vim.schedule_wrap(ref))
      end,
    })
  end,
}
