return {
	{
		"akinsho/flutter-tools.nvim",
		-- Only load when flutter is installed (i.e. on pjvds@Pieters-MacBook-Pro)
		enabled = vim.fn.executable("flutter") == 1,
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim",
		},
		config = function()
			require("flutter-tools").setup({
				ui = {
					border = "rounded",
					notification_style = "native",
				},
				decorations = {
					statusline = {
						app_version = true,
						device = true,
					},
				},
				lsp = {
					on_attach = require("nvchad.configs.lspconfig").on_attach,
					capabilities = require("nvchad.configs.lspconfig").capabilities,
					settings = {
						showTodos = true,
						completeFunctionCalls = true,
					},
				},
			})
		end,
	},
}
