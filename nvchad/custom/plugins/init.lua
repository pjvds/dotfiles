-- the following code tells Packer to install the neovim/nvim-lspconfig plugin using the code contained in nvim/lua/plugins/lspconfig.lua and nvim/lua/custom/plugins/lspconfig.lua respectively. For configuration, through, we need require calls.
-- Special attention should be paid to the sequence of the calls as they use the override technique, and reversing the order could result in inconsistencies in the configuration.
return {
  ["neovim/nvim-lspconfig"] = {
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.plugins.lspconfig"
    end,
    },
}
