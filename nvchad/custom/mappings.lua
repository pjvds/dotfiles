local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
  }
}

M.telescope = {
	n = {
		["<leader>A"] = { "<cmd> Telescope keymaps<CR>", "key mappings finder" },
		["<leader>f"] = { "<cmd> Telescope live_grep<CR>", "search in files" },
		["<leader>p"] = { "<cmd> Telescope find_files<CR>", "file finder" },
		["<leader>e"] = { "<cmd> Telescope find_files<CR>", "file finder" },
		["<leader>j"] = {
			function()
				vim.diagnostic.goto_next({
					-- call vim.diagnostic.open_float() after moving.
					float = true,
					-- loop around file
					wrap = true,
					-- jump to at least warning level or higher
					severity = { min = vim.diagnostic.severity.WARN },
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
