require("nvchad.options")

local o = vim.o

-- don't use the system clipboard
-- ctrl+c will copy to the clipboard in visual mode
o.clipboard = ""
