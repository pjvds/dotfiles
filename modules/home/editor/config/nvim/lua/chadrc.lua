-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.base46 = {
	-- Theme managed by `theme` CLI — reads from ~/.local/state/theme/nvim-theme
	theme = (function()
		local f = io.open(os.getenv("HOME") .. "/.local/state/theme/nvim-theme", "r")
		if f then
			local t = f:read("*l")
			f:close()
			if t and t ~= "" then return t end
		end
		return "nightowl"
	end)(),

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

-- Open telescope on startup if no files were passed
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		if #vim.fn.argv() == 0 then
			require("telescope.builtin").find_files({
				no_ignore = true,
			})
		end
	end,
})

return M
