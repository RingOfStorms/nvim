local pearing_dir = "/home/josh/projects/pearing"

if vim.fn.isdirectory(pearing_dir) ~= 1 then
	return {}
end

return {
	"joshuabell/pearing.nvim",
	dir = pearing_dir,
	dependencies = { "MunifTanjim/nui.nvim" },
	event = "VeryLazy",
	---@module "pearing"
	---@type pearing.Config
	opts = {
		enabled = true,
		provider = {
			model = "air-gpt-5.5", -- universal fallback
			models = {
				naming = "air-gpt-5.4-nano", -- fast, fire-and-forget
				watcher = "air-gpt-5.4-mini", -- ambient, wants speed
				interactive = { model = "air-gpt-5.5", reasoning_effort = "xhigh" }, -- you = planning
				planner = { model = "air-gpt-5.5", reasoning_effort = "xhigh" }, -- reserved role
				subagent = { model = "air-claude-opus-4.8", max_output_tokens = 128000 }, -- heavy code-writing
			},
		},
		approval = {
			mode = "yolo",
			kinds = {
				watcher = "normal",
			},
		},
	},
}

-- Flake-input variant (uncomment + remove the local-dir block above to use):
-- return {
-- 	"joshuabell/pearing.nvim",
-- 	dependencies = { "MunifTanjim/nui.nvim" },
-- 	event = "VeryLazy",
-- 	---@module "pearing"
-- 	---@type pearing.Config
-- 	opts = {},
-- }
