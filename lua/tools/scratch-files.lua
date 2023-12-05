-- Scratch files
local scratch = function(extension)
  os.execute("mkdir -p ~/dev/scratches/")
  local date = os.date("%Y-%m-%dT%H:%M:%S")
  local filepath = "~/dev/scratches/scratch_" .. date .. extension
  vim.cmd("execute 'edit " .. filepath .. "'")
end

require("util").keymaps_old({
  n = {
    ["<leader>fsw"] = {
      function()
        require("telescope.builtin").live_grep({
          search_dirs = { "~/dev/scratches/" },
        })
      end,
      desc = "Find Words in Scratches",
    },
    ["<leader>fsf"] = {
      function()
        require("telescope.builtin").find_files({
          search_dirs = { "~/dev/scratches/" },
        })
      end,
      desc = "Find Scratches",
    },
    ["<leader>s"] = { "<Nop>", desc = "Scratch File" },
    ["<leader>ss"] = {
      function()
        scratch(".txt")
      end,
      desc = "New [t]e[xt] scratch file",
    },
    ["<leader>sn"] = {
      function()
        scratch(".json")
      end,
      desc = "New json scratch file",
    },
    ["<leader>sm"] = {
      function()
        scratch(".md")
      end,
      desc = "New [m]ark[d]own scratch file",
    },
    ["<leader>sq"] = {
      function()
        scratch(".sql")
      end,
      desc = "New sql scratch file",
    },
    ["<leader>st"] = {
      function()
        scratch(".ts")
      end,
      desc = "New [t]ype[s]cript scratch file",
    },
    ["<leader>sb"] = {
      function()
        scratch(".sh")
      end,
      desc = "New [sh]ell scratch file",
    },
    ["<leader>sj"] = {
      function()
        scratch(".js")
      end,
      desc = "New [j]ava[s]cript scratch file",
    },
    ["<leader>sr"] = {
      function()
        scratch(".rs")
      end,
      desc = "New [r]u[s]t scratch file",
    },
  },
})
