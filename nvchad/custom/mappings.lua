local M = {}

M.general = {
	n = {
		[";"] = { ":", "enter command mode", opts = { nowait = true } },
		["<ESC>"] = { "<cmd> noh <CR>", "no highlight" },
	},
	v = {
		["<C-r>"] = { "hy:%s/<C-r>h//gc<left><left><left>", "find and replace current selection" },
		["<C-c>"] = { '"+y', "copy visual selection to clipboard" },
	},
}

M.telescope = {
	n = {
		["<C-A>"] = { "<cmd> Telescope keymaps<CR>", "key mappings finder" },
		["<leader>f"] = { "<cmd> Telescope live_grep<CR>", "search in files" },
		["<leader>p"] = { "<cmd> Telescope find_files<CR>", "file finder" },
		["<leader>e"] = { "<cmd> Telescope file_browser<CR>", "file browser" },
		["<leader>j"] = {
			function()
				vim.diagnostic.goto_next({
					-- call vim.diagnostic.open_float() after moving.
					float = true,
					-- loop around file
					wrap = true,
					-- jump to at least warning level or higher
					severity = { min = vim.diagnostic.severity.INFO },
				})
			end,
			"goto next diagnostics error",
		},
		["<leader>a"] = {
			function()
				vim.lsp.buf.code_action()
			end,
			"show lsp code actions for current buffer",
		},
	},
}

return M
