return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("configs.lspconfig")
		end,
	},
	{
		"dmmulroy/ts-error-translator.nvim",
		event = "LspAttach",
		config = function()
			require("ts-error-translator").setup()
		end,
	},
	{
		"nvim-java/nvim-java",
		commit = "db5536b4cb3da153084e50016596fd0e3a319aae",
		lazy = false,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"neovim/nvim-lspconfig",
			"mfussenegger/nvim-dap",
			{
				"JavaHello/spring-boot.nvim",
				commit = "218c0c26c14d99feca778e4d13f5ec3e8b1b60f0",
			},
		},
		config = function()
			local defaults = require("java.config")
			if defaults.jdtls.auto_install == nil then
				error("Installed nvim-java is too old for Nix-managed tools; update nvim-java through Lazy first")
			end
			local tools_path = vim.fn.stdpath("config") .. "-java/tools.json"
			if vim.fn.filereadable(tools_path) ~= 1 then
				error("Java tool paths are missing; rebuild your Home Manager configuration: " .. tools_path)
			end
			local tools = vim.json.decode(table.concat(vim.fn.readfile(tools_path), "\n"))
			require("java").setup(tools)
			vim.lsp.config("jdtls", {
				on_attach = require("nvchad.configs.lspconfig").on_attach,
				capabilities = require("nvchad.configs.lspconfig").capabilities,
				filetypes = { "java" },
			})
			vim.lsp.enable("jdtls")
		end,
	},
}
