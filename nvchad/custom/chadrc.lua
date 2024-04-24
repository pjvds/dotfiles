local M = {}

M.ui = {
	theme_toggle = { "aquarium", "github_dark" },
	theme = "github_dark",
	hl_override = {
		Visual = { -- custom highlights are also allowed
			bg = "#fffacd",
			fg = "black",
		},
	},
}
M.plugins = "custom.plugins"
M.mappings = require("custom.mappings")

M.nvimtree = {
	git = {
		enable = true,
	},
	filters = {
		custom = { ".DS_store" },
	},
}

return M
