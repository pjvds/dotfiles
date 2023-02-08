vim.g.mapleader = "'"

local autocmd = vim.api.nvim_create_autocmd

-- Send SIGUSR1 signal to kitty after config file changed to reload the configuration
autocmd("BufWritePost", {
  pattern = "*/kitty.conf",
  command = "!killall -SIGUSR1 kitty",
})
