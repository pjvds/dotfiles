return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			-- Ensure slint parser is installed
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "fsharp", "c_sharp" })
			end
		end,
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)

			-- Patch NvChad's broken TSInstallAll command (calls non-existent
			-- require("nvim-treesitter").install — correct API is nvim-treesitter.install)
			vim.api.nvim_create_user_command("TSInstallAll", function()
				local spec = require("lazy.core.config").plugins["nvim-treesitter"]
				local plugin_opts = type(spec.opts) == "table" and spec.opts or {}
				local langs = plugin_opts.ensure_installed or {}
				if #langs > 0 then
					require("nvim-treesitter.install").install {}(unpack(langs))
				end
			end, {})
		end,
	},
}
