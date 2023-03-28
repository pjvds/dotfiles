local M = {}

M.telescope = {
	border = true,
	borderchars = { "─", " ", "─", " ", "╭", "╮", "╯", "╰" },
}

M.nvimcmp = {
	sources = {
		{ name = "luasnip" },
		{ name = "nvim_lsp" },
		{ name = "buffer" },
		{ name = "nvim_lua" },
		{ name = "path" },
		{ name = "copilot" },
	},
}

return M
