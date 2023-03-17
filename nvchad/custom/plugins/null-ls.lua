local present, null_ls = pcall(require, "null-ls")

if not present then
	return
end

local b = null_ls.builtins

local sources = {
	-- format html and markdown
	b.formatting.prettierd,
	-- Lua formatting
	b.formatting.stylua,
	b.formatting.gofmt,
	b.diagnostics.golangci_lint,
	b.diagnostics.shellcheck,
	b.formatting.shfmt,
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local on_attach = function(client, bufnr)
	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
				vim.lsp.buf.formatting_sync()
			end,
		})
	end
end

null_ls.setup({
	debug = true,
	sources = sources,
	on_attach = on_attach,
})
