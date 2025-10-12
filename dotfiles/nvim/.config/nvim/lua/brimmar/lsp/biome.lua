return {
	cmd = { "biome", "lsp-proxy" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc" },
	root_markers = { "biome.json", "biome.jsonc", ".biomejs", ".git" },
	single_file_support = true,
	settings = {
		biome = {
			enable = true,
			organizeImportsOnSave = true,
			formatter = {
				enabled = true,
			},
			linter = {
				enabled = true,
			},
		},
	},
}
