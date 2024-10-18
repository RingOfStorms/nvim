return {
	"declancm/cinnamon.nvim",
	event = "VeryLazy",
	opts = {
		-- change default options here
		keymaps = { basic = true },
		mode = "cursor",
		step_size = {
			vertical = 3,
			horizontal = 4,
		},
		delay = 2,
	},
	config = function(_, opts)
		local cinnamon = require("cinnamon")
		cinnamon.setup(opts)

		-- Centered scrolling:
		vim.keymap.set("n", "<C-U>", function()
			cinnamon.scroll("<C-U>zz")
		end)
		vim.keymap.set("n", "<C-D>", function()
			cinnamon.scroll("<C-D>zz")
		end)

		-- LSP:
		vim.keymap.set("n", "gd", function()
			cinnamon.scroll(vim.lsp.buf.definition)
		end)
		vim.keymap.set("n", "gD", function()
			cinnamon.scroll(vim.lsp.buf.declaration)
		end)
	end,
}
