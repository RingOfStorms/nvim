-- snacks.nvim: Swiss-army-knife plugin replacing nvim-notify, cinnamon, vim-illuminate,
-- indent-blankline, openingh, dressing, telescope, telescope-file-browser, telescope-ui-select
return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@module "snacks"
	config = function()
		require("snacks").setup({
			-- Notifications (replaces nvim-notify)
			notifier = {
				enabled = true,
				timeout = 5000,
				top_down = false,
			},

			-- Smooth scrolling (replaces cinnamon.nvim)
			scroll = {
				enabled = true,
			},

			-- Word highlighting under cursor (replaces vim-illuminate)
			words = {
				enabled = true,
			},

			-- Indent guides (replaces indent-blankline.nvim)
			indent = {
				enabled = true,
				indent = {
					char = "│",
					only_scope = false,
					hl = {
						"SnacksIndent1",
						"SnacksIndent2",
						"SnacksIndent3",
						"SnacksIndent4",
						"SnacksIndent5",
					},
				},
				animate = {
					enabled = false,
				},
				scope = {
					enabled = true,
					char = "┊",
					hl = {
						"SnacksIndentScope1",
						"SnacksIndentScope2",
						"SnacksIndentScope3",
						"SnacksIndentScope4",
						"SnacksIndentScope5",
					},
				},
			},

			-- Better vim.ui.input (replaces dressing.nvim)
			input = {
				enabled = true,
			},

			-- Picker (replaces telescope.nvim + extensions)
			picker = {
				enabled = true,
				sources = {
					files = {
						hidden = true,
						follow = true,
						no_ignore = true,
						exclude = {
							"dist/",
							"build/",
							"target/",
							"node_modules/",
							"result/",
							"package-lock.json",
							".git/",
							".direnv/",
							".aider/",
							".pytest_cache",
							"__pycache__",
							".venv",
							".mypy_cache",
						},
					},
					grep = {
						hidden = true,
						follow = true,
						no_ignore = true,
						exclude = {
							"dist/",
							"build/",
							"target/",
							"node_modules/",
							"result/",
							"package-lock.json",
							".git/",
							".direnv/",
							".aider/",
							".pytest_cache",
							"__pycache__",
							".venv",
							".mypy_cache",
						},
					},
				},
			},

			-- Git browse (replaces openingh.nvim)
			gitbrowse = {
				enabled = true,
			},

			-- Scratch buffers (replaces custom tools/scratch-files.lua)
			scratch = {
				enabled = true,
			},

			-- Bigfile handling (new)
			bigfile = {
				enabled = true,
			},

			-- Quick file rendering (new)
			quickfile = {
				enabled = true,
			},

			-- Scope detection (new)
			scope = {
				enabled = true,
			},
		})
	end,
	init = function()
		-- Rainbow indent highlight groups — applied after colorscheme to override catppuccin defaults
		local function set_indent_highlights()
			vim.api.nvim_set_hl(0, "SnacksIndent1", { fg = "#915053" })
			vim.api.nvim_set_hl(0, "SnacksIndent2", { fg = "#A27F3E" })
			vim.api.nvim_set_hl(0, "SnacksIndent3", { fg = "#6B7F6E" })
			vim.api.nvim_set_hl(0, "SnacksIndent4", { fg = "#5a74aa" })
			vim.api.nvim_set_hl(0, "SnacksIndent5", { fg = "#6B6282" })
			vim.api.nvim_set_hl(0, "SnacksIndentScope1", { fg = "#CB5D60" })
			vim.api.nvim_set_hl(0, "SnacksIndentScope2", { fg = "#DEA93F" })
			vim.api.nvim_set_hl(0, "SnacksIndentScope3", { fg = "#89B790" })
			vim.api.nvim_set_hl(0, "SnacksIndentScope4", { fg = "#6289E5" })
			vim.api.nvim_set_hl(0, "SnacksIndentScope5", { fg = "#917DC0" })
		end
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				vim.schedule(set_indent_highlights)
			end,
		})
		-- Also run on VimEnter to catch the initial colorscheme load
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				vim.schedule(set_indent_highlights)
			end,
			once = true,
		})

		-- Check for essential tools
		if vim.fn.executable("rg") ~= 1 then
			vim.notify(
				"'rg' (ripgrep) not found. Required for live grep. Install it in your environment.",
				vim.log.levels.ERROR
			)
		end
		if vim.fn.executable("fd") ~= 1 then
			vim.notify("'fd' not found. File finding will be slower. Consider installing fd.", vim.log.levels.INFO)
		end
	end,
	keys = {
		-- Find
		{
			"<leader>ff",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>fg",
			function()
				Snacks.picker.git_files()
			end,
			desc = "Find Git Files",
		},
		{
			"<leader>fw",
			function()
				Snacks.picker.grep()
			end,
			desc = "Find Words (live grep)",
		},
		{
			"<leader>fW",
			function()
				Snacks.picker.grep({ dirs = { vim.fn.expand("%:p:h") } })
			end,
			desc = "Find Words in Current Dir",
		},
		{
			"<leader>fF",
			function()
				Snacks.picker.files({ dirs = { vim.fn.expand("%:p:h") } })
			end,
			desc = "Find Files in Current Dir",
		},
		{
			"<leader>fb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Find Buffer",
		},
		{
			"<leader>fc",
			function()
				Snacks.picker.commands()
			end,
			desc = "Find Commands",
		},
		{
			"<leader>fk",
			function()
				Snacks.picker.keymaps()
			end,
			desc = "Find Keymap",
		},
		{
			"<leader>fh",
			function()
				Snacks.picker.help()
			end,
			desc = "Find Help",
		},
		{
			"<leader>f/",
			function()
				Snacks.picker.lines()
			end,
			desc = "Buffer Lines",
		},
		{
			"<leader>fr",
			function()
				Snacks.picker.resume()
			end,
			desc = "Resume Last Picker",
		},
		{
			"<leader>fn",
			function()
				Snacks.notifier.show_history()
			end,
			desc = "Notification History",
		},
		{
			"<leader>fp",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files (picker)",
		},
		{
			"<leader>fl",
			function()
				Snacks.picker.files({ cwd = vim.fn.expand("%:p:h") })
			end,
			desc = "Find Files at Current Buffer",
		},

		-- LSP (via picker)
		{
			"<leader>lfr",
			function()
				Snacks.picker.lsp_references()
			end,
			desc = "Find LSP References",
			mode = { "n", "v", "x" },
		},

		-- Git
		{
			"<leader>gf",
			function()
				Snacks.gitbrowse()
			end,
			desc = "Open in GitHub",
			mode = { "n", "v" },
		},

		-- Scratch
		{
			"<leader>ss",
			function()
				Snacks.scratch()
			end,
			desc = "Toggle Scratch Buffer",
			mode = { "n", "v", "x" },
		},
		{
			"<leader>fss",
			function()
				Snacks.scratch.select()
			end,
			desc = "Select Scratch Buffer",
		},

		-- Dismiss notifications
		{
			"<leader>un",
			function()
				Snacks.notifier.hide()
			end,
			desc = "Dismiss All Notifications",
		},

		-- Words (navigate references)
		{
			"]]",
			function()
				Snacks.words.jump(vim.v.count1)
			end,
			desc = "Next Reference",
			mode = { "n", "t" },
		},
		{
			"[[",
			function()
				Snacks.words.jump(-vim.v.count1)
			end,
			desc = "Prev Reference",
			mode = { "n", "t" },
		},
	},
}
