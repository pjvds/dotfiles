return {
	{
		"wellle/context.vim",
		event = "LspAttach",
		config = function()
			vim.g.context_enabled = true
			vim.g.context_exclude_filetypes = { "toggleterm", "TelescopePrompt", "alpha", "NvimTree" }
		end,
	},
	{
		"Bekaboo/dropbar.nvim",
		event = "LspAttach",
		opts = {
			symbols = {
				separator = " > ",
				ellipsis = "...",
			},
			winbar = {
				enable = true,
				show_file = true,
			},
			mappings = {
				["<Leader>;"] = "pick",
				["[;"] = "goto_context_start",
				["];"] = "select_next_context",
			},
		},

	},
	{
		"nvim-tree/nvim-tree.lua",
		opts = {
			renderer = {
				group_empty = true,
			},
			view = {
				side = "left",
				adaptive_size = true,
			},
		},
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},
}