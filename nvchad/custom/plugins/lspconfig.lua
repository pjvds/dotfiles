-- custom.plugins.lspconfig
local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- hint: all lang server names can be found here:
--       https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- or by: `:help lspconfig-all`
local servers = { "tsserver", "gopls", "sumneko_lua", "jsonls" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end
