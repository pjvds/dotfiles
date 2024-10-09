require("nvchad.mappings")

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<leader>n", "<cmd> NvimTreeToggle<CR>", { desc = "toggle nvim tree" })

map("v", "<C-r>", '"hy:%s/<C-r>h//gc<left><left><left>', { desc = "find and replace current selection" })
map("v", "<C-c>", '"+y', { desc = "copy visual selection to clipboard" })

map("n", "<C-A>", "<cmd> Telescope keymaps<CR>", { desc = "key mappings finder" })
map("n", "<leader>b", "<cmd> Telescope buffers<CR>", { desc = "buffers browser" })
map("n", "<leader>f", "<cmd> Telescope live_grep<CR>", { desc = "search in files" })
map("n", "<leader>p", "<cmd> Telescope find_files<CR>", { desc = "file finder" })
map("n", "<leader>e", "<cmd> Telescope file_browser<CR>", { desc = "file browser" })
map("n", "<leader>x", "<cmd> Telescope diagnostics<CR>", { desc = "diagnostic browser" })
map("n", "<leader>r", "<cmd> Telescope resume<CR>", { desc = "resume browser" })
map("v", "<leader>f", function()
	require("telescope.builtin").grep_string()
end, { desc = "search in files for highlight" })
map("n", "<leader>j", function()
	vim.diagnostic.goto_next({
		-- call vim.diagnostic.open_float() after moving.
		float = {
			show_header = true,
			source = "if_many",
			border = "rounded",
			focusable = false,
		},
		-- loop around file
		wrap = true,
		-- jump to at least warning level or higher
		severity = { min = vim.diagnostic.severity.INFO },
	})
end, { desc = "goto next diagnostics error" })
map("n", "<leader>a", function()
	vim.lsp.buf.code_action()
end, { desc = "show lsp code actions for current buffer" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
