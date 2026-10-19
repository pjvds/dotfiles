return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		event = {},
		cmd = { "TSInstall", "TSUpdate", "TSUninstall", "TSLog" },
		opts = {
			ensure_installed = { "lua", "luadoc", "printf", "vim", "vimdoc", "fsharp", "c_sharp", "dart", "slint" },
		},
		config = function()
			local treesitter = require("nvim-treesitter")
			if type(treesitter.install) ~= "function" then
				error("Tree-sitter is still on the legacy branch; update nvim-treesitter through Lazy")
			end
			treesitter.setup({})
		end,
	},
}
