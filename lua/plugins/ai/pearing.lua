return {
	"joshuabell/pearing.nvim",
	dir = "/home/josh/projects/pearing",
	dependencies = { "MunifTanjim/nui.nvim" },
	event = "VeryLazy",
	---@module "pearing"
	---@type pearing.Config
	opts = {},
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
