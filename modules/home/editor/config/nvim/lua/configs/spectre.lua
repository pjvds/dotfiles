return function()
	require("spectre").setup({
		find_engine = {
			["rg"] = {
				cmd = "rg",
				args = {
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--no-ignore",
					"--hidden",
					"-g",
					"!node_modules/*",
					"-g",
					"!.yarn",
					"-g",
					"!.git/logs",
					"-g",
					"!type-docs",
					"-g",
					"!build",
					"-g",
					"!local-build",
					"-g",
					"!storybook-static",
					"-g",
					"!coverage/*",
				},
			},
		},
	})

	-- Map :w to trigger find and replace in Spectre buffers
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "spectre_panel",
		callback = function()
			-- Override :w command to trigger replace
			vim.api.nvim_buf_create_user_command(0, "Write", function()
				require("spectre.actions").run_replace()
			end, {})

			vim.cmd([[cnoreabbrev <buffer> w Write]])
		end,
	})
end
