local overrides = require("custom.configs.overrides")

local plugins = {
	{
		-- hint for cmp config debugging:
		-- CmpStatus gives the full status of cmp
		"hrsh7th/nvim-cmp",
		opts = overrides.nvimcmp,
		dependencies = {
			"zbirenbaum/copilot-cmp",
			dependencies = {
				"zbirenbaum/copilot.lua",
				cmd = "Copilot",
				config = function()
					require("copilot").setup({})
				end,
			},
			config = function()
				require("copilot_cmp").setup()
			end,
		},
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		config = function()
			local t = require("telescope")
			t.load_extension("file_browser")
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			local present, null_ls = pcall(require, "null-ls")

			if not present then
				return
			end

			local b = null_ls.builtins

			local sources = {
				-- format html and markdown
				b.formatting.prettierd,
				-- Lua formatting
				b.formatting.stylua,
				b.formatting.gofmt,
				b.diagnostics.golangci_lint,
				b.diagnostics.shellcheck,
				b.formatting.shfmt,
			}

			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
			local on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
							vim.lsp.buf.formatting_sync()
						end,
					})
				end
			end

			null_ls.setup({
				debug = true,
				sources = sources,
				on_attach = on_attach,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- format & linting
			{
				"jose-elias-alvarez/null-ls.nvim",
				config = function()
					require("custom.configs.null-ls")
				end,
			},
		},
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end, -- Override to setup mason-lspconfig
	},
	{ "psliwka/vim-smoothie" },
	{
		"mg979/vim-visual-multi",
		opt = true,
		event = "BufReadPost",
		setup = function()
			--require("custom.plugins.configs.visual-multi")
		end,
	},
	{
		"nmac427/guess-indent.nvim",
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
	{
		"andweeb/presence.nvim",
		after = "telescope.nvim",
		config = function()
			require("presence").setup({
				auto_update = true, -- Update activity based on autocmd events (if `false`, map or manually execute `:lua package.loaded.presence:update()`)
				neovim_image_text = "How do I quit this edit?", -- Text displayed when hovered over the Neovim image
				main_image = "neovim", -- Main image display (either "neovim" or "file")
				debounce_timeout = 10, -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
				enable_line_number = true, -- displays the current line number instead of the current project
				buttons = false, -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table (`{{ label = "<label>", url = "<url>" }, ...}`, or a function(buffer: string, repo_url: string|nil): table)
				file_assets = {}, -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)
				show_time = false, -- Show the timer

				-- Rich Presence text options
				editing_text = "Editing...", -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
				file_explorer_text = "Browsing...", -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
				git_commit_text = "Committing changes", -- Format string rendered when committing changes in git (either string or function(filename: string): string)
				plugin_manager_text = "Managing plugins", -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
				reading_text = "Reading...", -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
				workspace_text = "", -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
				line_number_text = "Line %s out of %s", -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
			})
		end,
	},
}

return plugins
