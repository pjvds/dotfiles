vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46/"
vim.g.mapleader = "'"

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- if lazy is not installed, install it
if not vim.uv.fs_stat(lazypath) then
	local repo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath })
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require("configs.lazy")

-- load plugins
require("lazy").setup({
	{
		"NvChad/NvChad",
		lazy = false,
		branch = "v2.5",
		import = "nvchad.plugins",
	},

	{ import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require("options")
require("nvchad.autocmds")

vim.api.nvim_create_user_command("LspInfo", function()
	vim.cmd("checkhealth vim.lsp")
end, { desc = "Show LSP status via checkhealth" })

vim.api.nvim_create_user_command("Cpath", function()
	local path = vim.api.nvim_buf_get_name(0)
	if path == "" then
		vim.notify("Current buffer has no file path", vim.log.levels.WARN)
		return
	end
	vim.fn.setreg("+", path)
	vim.notify("Copied path: " .. path)
end, { desc = "Copy current file's full path to the system clipboard" })

vim.cmd([[cnoreabbrev <expr> cpath getcmdtype() == ':' && getcmdline() == 'cpath' ? 'Cpath' : 'cpath']])

vim.schedule(function()
	require("mappings")
end)
