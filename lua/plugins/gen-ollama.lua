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
  opts = {
    model = "codellama",
    -- show_prompt = true,
    show_model = true,
  },
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
      Inline_Selection_Code_Completion = {
        prompt = "Rewrite the following code, follow any comment instructions.\nRemove any instruction comments but keep comments about the code. Only output the result with no explanation in format ```$filetype\n...\n```:n```$filetype\n$text\n```",
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
    -- For some reason selections don't work well when using keys from lazy + which key installed when using `<cmd>` MUST use `:` for command
    {
      "<leader>x<leader>",
      ":Gen<cr>",
      desc = "Show Menu",
      mode = { "n", "v", "x" },
    },
    {
      "<leader>xm",
      function()
        require("gen").select_model()
      end,
      desc = "Show Menu",
      mode = { "n", "v", "x" },
    },
    {
      "<leader>xx",
      ":Gen Prompt_Code_Completion<cr>",
      desc = "Input and generate",
      mode = { "n" },
    },
    {
      "<leader>xx",
      ":'<,'>Gen Inline_Selection_Code_Completion<cr>",
      desc = "Replace selected code",
      mode = { "v", "x" },
    },
    {
      "<leader>xc",
      ":Gen Prompt_And_Answer_Float<cr>",
      desc = "Prompt and answer in float window",
      mode = { "n", "v", "x" },
    },
    {
      "<leader>xi",
      ":Gen Prompt_And_Answer_Inline<cr>",
      desc = "Prompt and answer inline at cursor",
      mode = { "n", "v", "x" },
    },
    {
      "<leader>xs",
      ":'<,'>Gen Summarize_Selection_Float<cr>",
      desc = "Summarize selection in float window",
      mode = { "v", "x" },
    },
    {
      "<leader>xa",
      ":'<,'>Gen Ask_Selection_Float<cr>",
      desc = "Ask question about selection in float window",
      mode = { "v", "x" },
    },
  },
}
