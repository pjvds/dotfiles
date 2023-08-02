vim.g.mapleader = "'"

-- don't use system clipboard
vim.opt.clipboard = ""

local opt = vim.opt
local autocmd = vim.api.nvim_create_autocmd

-- custom undo, swp and backup folder
local prefix = vim.env.XDG_CONFIG_HOME or vim.fn.expand("~/.config/nvim")
opt.undodir = { prefix .. "/.undo//"}
opt.backup = true
opt.backupdir = {prefix .. "/.backup//"}
opt.swapfile = false

-- Send SIGUSR1 signal to kitty after config file changed to reload the configuration
autocmd("BufWritePost", {
	pattern = "*/kitty.conf",
	command = "!killall -SIGUSR1 kitty",
})
