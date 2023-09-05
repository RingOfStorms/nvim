return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = { enabled = false, auto_trigger = false },
      panel = { enabled = false, auto_trigger = false },
    },
    config = function(_, opts)
      require("copilot").setup(opts)
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    opts = {},
    config = function(_, opts)
      require("copilot_cmp").setup(opts)
    end,
    keys = {
      {
        "<leader>ct",
        function()
          require("copilot.suggestion").toggle_auto_trigger()
        end,
        desc = "Toggle copilot suggestions.",
      },
    },
  },
}
