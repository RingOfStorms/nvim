return {
	"johmsalas/text-case.nvim",
	config = function(_, opts)
		require("textcase").setup(opts)
	end,
	keys = {
		{
			"<leader>,c",
			function()
				local textcase = require("textcase")
				local plugin = require("textcase.plugin.plugin")
				local presets = require("textcase.plugin.presets")
				local constants = require("textcase.shared.constants")
				local utils = require("textcase.shared.utils")
				local api = textcase.api

				local mode = vim.api.nvim_get_mode().mode
				local is_visual = mode == "v" or mode == "V" or mode == "\22"

				plugin.state.telescope_previous_mode = mode
				plugin.state.telescope_previous_buffer = vim.api.nvim_get_current_buf()
				if is_visual then
					plugin.state.telescope_previous_visual_region =
						utils.get_visual_region(0, true, nil, utils.get_mode_at_operator(mode))
				end

				local methods = {
					api.to_upper_case,
					api.to_lower_case,
					api.to_snake_case,
					api.to_dash_case,
					api.to_title_dash_case,
					api.to_constant_case,
					api.to_dot_case,
					api.to_comma_case,
					api.to_phrase_case,
					api.to_camel_case,
					api.to_pascal_case,
					api.to_title_case,
					api.to_path_case,
				}

				local items = {}
				local function add_items(prefix, change_type)
					for _, method in ipairs(methods) do
						if presets.options.enabled_methods_set[method.method_name] then
							table.insert(items, {
								label = prefix .. method.desc,
								method_name = method.method_name,
								type = change_type,
							})
						end
					end
				end

				if is_visual then
					add_items("Convert to ", constants.change_type.VISUAL)
				else
					add_items("Convert to ", constants.change_type.CURRENT_WORD)
					add_items("LSP rename ", constants.change_type.LSP_RENAME)
				end

				vim.ui.select(items, {
					prompt = "Text Case:",
					format_item = function(item)
						return item.label
					end,
				}, function(choice)
					if not choice then
						return
					end
					if choice.type == constants.change_type.CURRENT_WORD then
						plugin.current_word(choice.method_name)
					elseif choice.type == constants.change_type.LSP_RENAME then
						plugin.lsp_rename(choice.method_name)
					elseif choice.type == constants.change_type.VISUAL then
						plugin.visual(choice.method_name)
					end
				end)
			end,
			desc = "Change case of selection",
			mode = { "n", "v", "x" },
		},
	},
}
