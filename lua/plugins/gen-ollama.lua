local U = require("util")

return {
  "David-Kunz/gen.nvim",
  enabled = function()
    return U.cmd_executable("ollama", {
      [false] = function()
        vim.notify("ollama not installed, gen disabled", 2)
      end,
    }) and U.cmd_executable("curl", {
      [false] = function()
        vim.notify("curl not installed, gen disabled", 2)
      end,
    })
  end,
  config = function(_, opts)
    local g = require("gen")
    g.setup(opts)
    -- https://github.com/David-Kunz/gen.nvim/tree/main#custom-prompts
    -- prompt: (string | function) Prompt either as a string or a function which should return a string. The result can use the following placeholders:
    --     $text: Visually selected text
    --     $filetype: Filetype of the buffer (e.g. javascript)
    --     $input: Additional user input
    --     $register: Value of the unnamed register (yanked text)
    -- replace: true if the selected text shall be replaced with the generated output
    -- extract: Regular expression used to extract the generated result
    -- model: The model to use, e.g. zephyr, default: mistral
    g.prompts = {
      -- https://github.com/David-Kunz/gen.nvim/blob/main/lua/gen/prompts.lua
      Prompt_Code_Completion = {
        prompt = "Write code that meets these requirements: $input\nOnly output the result in format ```$filetype\n...\n```",
        replace = true,
        extract = "```$filetype\n(.-)```",
      },
      Replace_Code_Completion = {
        prompt = "Rewrite the following code, follow any comment instructions.\nOnly output the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
        replace = true,
        extract = "```$filetype\n(.-)```",
      },
      Prompt_And_Answer_Float = { prompt = "$input" },
      Prompt_And_Answer_Inline = { prompt = "$input", replace = true },
      Summarize_Selection_Float = { prompt = "Summarize the following text:\n$text" },
      Ask_Selection_Float = {
        prompt = "Answer these requirements given the following text: $input\n\nTEXT:\n```\n$text\n```",
      },
    }
  end,
  keys = {
    {
      "<leader>xm",
      "<cmd>Gen<cr>",
      desc = "Show Menu",
      mode = { "n", "v", "x" },
    },
    {
      "<leader>xx",
      "<cmd>Gen Prompt_Code_Completion<cr>",
      desc = "Input and generate",
      mode = { "n" },
    },
    {
      "<leader>xx",
      "<cmd>'<,'>Gen Replace_Code_Completion<cr>",
      desc = "Replace selected code",
      mode = { "v", "x" },
    },
    {
      "<leader>xc",
      "<cmd>Gen Prompt_And_Answer_Float<cr>",
      desc = "Prompt and answer in float window",
      mode = { "n", "v", "x" },
    },
    {
      "<leader>xcc",
      "<cmd>Gen Prompt_And_Answer_Inline<cr>",
      desc = "Prompt and answer inline at cursor",
      mode = { "n", "v", "x" },
    },
    {
      "<leader>xs",
      "<cmd>'<,'>Gen Summarize_Selection_Float<cr>",
      desc = "Summarize selection in float window",
      mode = { "v", "x" },
    },
    {
      "<leader>xa",
      "<cmd>'<,'>Gen Ask_Selection_Float<cr>",
      desc = "Ask question about selection in float window",
      mode = { "v", "x" },
    },
  },
}
