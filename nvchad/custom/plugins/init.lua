-- the following code tells Packer to install the neovim/nvim-lspconfig plugin using the code contained in nvim/lua/plugins/lspconfig.lua and nvim/lua/custom/plugins/lspconfig.lua respectively. For configuration, through, we need require calls.
-- Special attention should be paid to the sequence of the calls as they use the override technique, and reversing the order could result in inconsistencies in the configuration.
return {
	["jose-elias-alvarez/null-ls.nvim"] = {
		after = "nvim-lspconfig",
		config = function()
			require("custom.plugins.null-ls")
		end,
	},
	["neovim/nvim-lspconfig"] = {
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.plugins.lspconfig")
		end,
	},
	["psliwka/vim-smoothie"] = {},
	["mg979/vim-visual-multi"] = {
		opt = true,
		event = "BufReadPost",
		setup = function()
			--require("custom.plugins.configs.visual-multi")
		end,
	},
	["nmac427/guess-indent.nvim"] = {
		event = "InsertEnter",
		config = function()
			require("guess-indent").setup({
				auto_cmd = true, -- Set to false to disable automatic execution
				filetype_exclude = { -- A list of filetypes for which the auto command gets disabled
					"netrw",
					"tutor",
				},
				buftype_exclude = { -- A list of buffer types for which the auto command gets disabled
					"help",
					"nofile",
					"terminal",
					"prompt",
				},
			})
		end,
	},
}
