local M = {}

M.ui = {
	theme_toggle = { "monekai", "aye-light" },
	theme = "monekai",
	hl_override = {
		Visual = { -- custom highlights are also allowed
			bg = "#fffacd",
			fg = "black",
		},
	},
}
M.plugins = "custom.plugins"
M.mappings = require("custom.mappings")

return M
