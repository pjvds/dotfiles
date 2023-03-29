-- custom.plugins.lspconfig
local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")

-- hint: all lang server names can be found here:
--       https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- or by: `:help lspconfig-all`
local servers = { "tsserver", "gopls", "lua_ls", "jsonls", "graphql", "csharp_ls", "rust_analyzer" }

for _, lsp in ipairs(servers) do
	local opts = {
		on_attach = on_attach,
		capabilities = capabilities,
	}

	if lsp == "lua_ls" then
		opts.settings = {
			Lua = {
				diagnostics = { globals = { "vim" } },
			},
		}
	end

	lspconfig[lsp].setup(opts)
end
