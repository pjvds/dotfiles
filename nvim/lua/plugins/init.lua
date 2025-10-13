return {
	import = "nvchad.blink.lazyspec",
	{ "vuciv/golf", event = "VeryLazy" },
	{
		"kawre/leetcode.nvim",
		build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
		cmd = "Leet",
		dependencies = {
			-- include a picker of your choice, see picker section for more details
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		opts = {
			-- configuration goes here
		},
	},
	{
		"wellle/context.vim",
		event = "LspAttach",
		config = function()
			vim.g.context_enabled = true
			vim.g.context_exclude_filetypes = { "toggleterm", "TelescopePrompt", "alpha", "NvimTree" }
			vim.keymap.set("n", "<Leader>uc", ":ContextToggle<CR>", { desc = "Toggle context" })
		end,
	},
	{
		"Bekaboo/dropbar.nvim",
		event = "LspAttach",
		opts = {
			-- configuration
			symbols = {
				separator = " > ",
				-- limit = 3, -- limit number of symbols in winbar
				ellipsis = "...", -- when limit is exceeded
				-- show_file = true, -- whether to show file name in winbar
				-- file_formatter = function(filename) -- function to format filename in winbar
				--   return filename
				-- end,
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
		-- optional, but required for fuzzy finder support
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		config = function()
			local dropbar_api = require("dropbar.api")
			vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
			vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
			vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
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
		"mg979/vim-visual-multi",
		event = "VeryLazy",
	},
	{
		"github/copilot.vim",
		lazy = false,
		config = function()
			-- Mapping tab is already used by NvChad
			vim.g.copilot_no_tab_map = true
			vim.g.copilot_assume_mapped = true
			vim.g.copilot_tab_fallback = ""
			-- The mapping is set to other key, see custom/lua/mappings
			-- or run <leader>ch to see copilot mapping section
		end,
	},
	{
		"ggandor/leap.nvim",
		keys = {
			{ "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
			{ "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
			{ "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
		},
		config = function(_, opts)
			local leap = require("leap")
			for k, v in pairs(opts) do
				leap.opts[k] = v
			end
			leap.add_default_mappings(true)
		end,
	},
	-- relative line numbers in insert mode
	{
		"pjvds/dynumbers.nvim",
		event = "VeryLazy",
		config = function()
			require("dynumbers").setup()
		end,
	},
	{
		"nvim-java/nvim-java",
		enabled = false,
		lazy = false,
		dependencies = {
			"nvim-java/lua-async-await",
			"nvim-java/nvim-java-core",
			"nvim-java/nvim-java-test",
			"nvim-java/nvim-java-dap",
			"MunifTanjim/nui.nvim",
			"neovim/nvim-lspconfig",
			"mfussenegger/nvim-dap",
			{
				"williamboman/mason.nvim",
				opts = {
					registries = {
						"github:nvim-java/mason-registry",
						"github:mason-org/mason-registry",
					},
				},
			},
		},
		config = function()
			require("java").setup({})
			require("lspconfig").jdtls.setup({
				on_attach = require("nvchad.configs.lspconfig").on_attach,
				capabilities = require("nvchad.configs.lspconfig").capabilities,
				filetypes = { "java" },
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		event = "BufWritePre", -- uncomment for format on save
		config = function()
			require("configs.conform")
		end,
	},
	-- make scrolling smooth and nice
	{
		"psliwka/vim-smoothie",
		event = "BufRead",
	},
	-- Blazing fast indentarion style detection for Neovim written in Lua.
	-- The goal of this plugin is to automatically detect the indentation
	-- style used in a buffer and updating the buffer options accordingly.
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
		"nvim-telescope/telescope.nvim",
		opts = function(_, conf)
			conf.defaults.path_display = {
				filename_first = {
					reverse_directories = false,
				},
			}

			-- conf.defaults.mappings.i = {
			--   ["<C-j>"] = require("telescope.actions").move_selection_next,
			--   ["<Esc>"] = require("telescope.actions").close,
			-- }

			-- or
			-- table.insert(conf.defaults.mappings.i, your table)
			return conf
		end,
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
		"neovim/nvim-lspconfig",
		config = function()
			require("configs.lspconfig")
		end,
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
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
		},
	},
	{
		"nvim-pack/nvim-spectre",
		event = { "VeryLazy" },
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{ "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
			{ "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
			{ "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
		},

		config = function()
			require("spectre").setup({
				find_engine = {
					["rg"] = {
						cmd = "rg",
						args = {
							"--color=never",
							"--no-heading",
							"--with-filename",
							"--line-number",
							"--column",
							"--no-ignore",
							"--hidden",
							"-g",
							"!node_modules/*",
							"-g",
							"!.yarn",
							"-g",
							"!.git/logs",
							"-g",
							"!type-docs",
							"-g",
							"!build",
							"-g",
							"!local-build",
							"-g",
							"!storybook-static",
							"-g",
							"!coverage/*",
						},
					},
				},
			})

			vim.keymap.set("n", "<leader>h", '<cmd>lua require("spectre").toggle()<CR>', {
				desc = "Toggle Spectre",
			})
			vim.keymap.set("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
				desc = "Search current word",
			})
			vim.keymap.set("n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
				desc = "Search on current file",
			})
		end,
	},
	-- These are some examples, uncomment them if you want to see them work!
	-- {
	--   "neovim/nvim-lspconfig",
	--   config = function()
	--     require("nvchad.configs.lspconfig").defaults()
	--     require "configs.lspconfig"
	--   end,
	-- },
	--
	-- {
	-- 	"williamboman/mason.nvim",
	-- 	opts = {
	-- 		ensure_installed = {
	-- 			"lua-language-server", "stylua",
	-- 			"html-lsp", "css-lsp" , "prettier"
	-- 		},
	-- 	},
	-- },
	--
	-- {
	-- 	"nvim-treesitter/nvim-treesitter",
	-- 	opts = {
	-- 		ensure_installed = {
	-- 			"vim", "lua", "vimdoc",
	--      "html", "css"
	-- 		},
	-- 	},
	-- },
}
