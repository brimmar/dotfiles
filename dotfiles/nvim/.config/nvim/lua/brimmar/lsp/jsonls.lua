return {
	cmd = { "vscode-json-language-server", "--stdio" },
	filetypes = { "json", "jsonc" },
	root_markers = { ".git", "package.json" },
	init_options = {
		provideFormatter = true,
	},
	settings = {
		json = {
			schemas = {
				{
					fileMatch = { "package.json" },
					url = "https://json.schemastore.org/package.json",
				},
				{
					fileMatch = { "tsconfig*.json" },
					url = "https://json.schemastore.org/tsconfig.json",
				},
				{
					fileMatch = { ".eslintrc.json", ".eslintrc" },
					url = "https://json.schemastore.org/eslintrc.json",
				},
			},
			validate = { enable = true },
		},
	},
}
