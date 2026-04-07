require("nvchad.options")

local o = vim.o

-- don't use the system clipboard
-- ctrl+c will copy to the clipboard in visual mode
o.clipboard = ""

-- Set visual selection to custom yellow (RGB: 254, 248, 143)
vim.api.nvim_set_hl(0, "Visual", { bg = "#FEF88F", fg = "#000000" })

-- Ensure it persists after colorscheme loads
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		vim.api.nvim_set_hl(0, "Visual", { bg = "#FEF88F", fg = "#000000" })
	end,
})
