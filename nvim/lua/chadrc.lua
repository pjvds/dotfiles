-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.base46 = {
	-- my favorite colorschemes
	theme = "palenight",

	-- hl_override = {
	-- 	Comment = { italic = true },
	-- 	["@comment"] = { italic = true },
	-- },
}

-- Send SIGUSR1 signal to kitty after config file changed to reload the configuration
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*/kitty.conf",
	command = "!killall -SIGUSR1 kitty",
})

return M
