vim.g.mapleader = "'"

-- don't use system clipboard
vim.opt.clipboard = ""

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local group = augroup("toggling-numbers", {})

-- line number
vim.wo.number = true
vim.wo.relativenumber = true

autocmd("ModeChanged", {
	pattern = { "*:i*", "i*:*" },
	group = group,
	callback = function()
		vim.o.relativenumber = vim.v.event.new_mode:match("^i") == nil
	end,
})

-- Send SIGUSR1 signal to kitty after config file changed to reload the configuration
autocmd("BufWritePost", {
	pattern = "*/kitty.conf",
	command = "!killall -SIGUSR1 kitty",
})
