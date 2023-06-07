local M = {};

function M.keymaps(mappings)
	for mode, maps in pairs(mappings) do
		for keymap, options in pairs(maps) do
			if options then
				local cmd = options
				local keymap_opts = {}
				if type(options) == "table" then
					cmd = options[1]
					keymap_opts = vim.tbl_deep_extend("force", keymap_opts, options)
					keymap_opts[1] = nil
				end

				if mode and keymap and cmd and keymap_opts then
					vim.keymap.set(mode, keymap, cmd, keymap_opts)
				end
			end
		end
	end
end

return M

