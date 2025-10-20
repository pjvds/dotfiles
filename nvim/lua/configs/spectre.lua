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
end