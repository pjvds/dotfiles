-- Slint Language Server configuration
-- LSP for .slint UI files with syntax highlighting and live preview

return {
	-- Syntax highlighting for .slint files
	{
		"slint-ui/vim-slint",
		ft = "slint",
	},

	-- Tree-sitter syntax highlighting and indentation
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			-- Ensure slint parser is installed
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "slint" })
			end
		end,
	},

	-- Mason LSP installer - adds slint-lsp
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "slint-lsp" })
		end,
	},

	-- LSP configuration
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				slint_lsp = {
					-- slint-lsp is auto-configured by lspconfig
					-- No extra config needed - it works out of the box!
				},
			},
		},
		config = function()
			-- Auto-setup happens in configs/lspconfig.lua
			require("configs.lspconfig")
		end,
	},
}
