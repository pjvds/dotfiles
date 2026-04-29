-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

-- servers with default config
local servers = {
	"ts_ls",
	"html",
	"cssls",
	"gopls",
	"jsonls",
	"graphql",
	"csharp_ls",
	"rust_analyzer",
	"terraformls",
	"pyright",
	"slint_lsp",
}

vim.lsp.config("yamlls", {
	settings = {
		yaml = {
			schemaStore = {
				enable = true,
			},
			schemas = {
				["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
				["https://raw.githubusercontent.com/argoproj/argo-workflows/main/api/jsonschema/schema.json"] = "**/*.argo.yaml",
			},
		},
	},
})

local vue_language_server_path = vim.fn.expand("$MASON/packages")
	.. "/vue-language-server"
	.. "/node_modules/@vue/language-server"

vim.lsp.config("vtsls", {
	settings = {
		vtsls = {
			tsserver = {
				globalPlugins = {
					{
						name = "@vue/typescript-plugin",
						location = vue_language_server_path,
						languages = { "vue" },
						configNamespace = "typescript",
					},
				},
			},
		},
	},
	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
})

vim.lsp.config("vue_ls", {
	on_init = function(client)
		client.handlers["tsserver/request"] = function(_, result, context)
			local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = "vtsls" })
			if #clients == 0 then
				vim.notify(
					"Could not found `vtsls` lsp client, vue_lsp would not work without it.",
					vim.log.levels.ERROR
				)
				return
			end
			local ts_client = clients[1]

			local param = unpack(result)
			local id, command, payload = unpack(param)
			ts_client:exec_cmd({
				title = "vue_request_forward",
				command = "typescript.tsserverRequest",
				arguments = {
					command,
					payload,
				},
			}, { bufnr = context.bufnr }, function(_, r)
				local response_data = { { id, r.body } }
				client:notify("tsserver/response", response_data)
			end)
		end
	end,
})

vim.lsp.enable(servers)
vim.lsp.enable("yamlls")
vim.lsp.enable("vtsls")
vim.lsp.enable("vue_ls")
