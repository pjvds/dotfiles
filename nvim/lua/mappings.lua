require("nvchad.mappings")

-- add yours here

local map = vim.keymap.set

vim.keymap.set("n", "YY", function()
	vim.cmd("%yank +")
	vim.cmd('echo "Buffer copied to clipboard"')
end, { noremap = true, silent = true, desc = "Copy buffer to system clipboard" })

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<leader>n", "<cmd> NvimTreeToggle<CR>", { desc = "toggle nvim tree" })

map("v", "<C-r>", '"hy:%s/<C-r>h//gc<left><left><left>', { desc = "find and replace current selection" })
map("v", "<C-c>", '"+y', { desc = "copy visual selection to clipboard" })

map("n", "<leader>t", function()
	require("nvchad.themes").open()
end, { desc = "key mappings finder" })
map("n", "<C-A>", "<cmd> Telescope keymaps<CR>", { desc = "key mappings finder" })
map("n", "<leader>b", "<cmd> Telescope buffers<CR>", { desc = "buffers browser" })
map("n", "<leader>f", "<cmd> Telescope live_grep hidden=true no_ignore=true<CR>", { desc = "search in files" })
map("n", "<leader>p", function()
	require("telescope.builtin").find_files({
		hidden = true,
		no_ignore = true,
	})
end, { desc = "file finder" })
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
		severity = { min = vim.diagnostic.severity.HINT },
	})
end, { desc = "goto next diagnostics error" })
map("n", "<leader>a", function()
	vim.lsp.buf.code_action()
end, { desc = "show lsp code actions for current buffer" })

map("i", "<C-l>", function()
	vim.fn.feedkeys(vim.fn["copilot#Accept"](), "")
end, {
	desc = "Copilot Accept",
})

-- Context plugin
map("n", "<Leader>uc", ":ContextToggle<CR>", { desc = "Toggle context" })

-- Dropbar plugin
map("n", "<Leader>;", function() require("dropbar.api").pick() end, { desc = "Pick symbols in winbar" })
map("n", "[;", function() require("dropbar.api").goto_context_start() end, { desc = "Go to start of current context" })
map("n", "];", function() require("dropbar.api").select_next_context() end, { desc = "Select next context" })

-- Spectre plugin
map("n", "<leader>h", '<cmd>lua require("spectre").toggle()<CR>', { desc = "Toggle Spectre" })
map("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', { desc = "Search current word" })
map("n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', { desc = "Search on current file" })