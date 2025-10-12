return {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = { "go.mod", ".git" },
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
				shadow = true,
			},
			staticcheck = true,
			usePlaceholders = true,
			gofumpt = true,
			completionDocumentation = true,
			completeUnimported = true,
			matcher = "fuzzy",
			symbolMatcher = "fuzzy",
			semanticTokens = true,
			codelenses = {
				generate = true,
				regenerate_cgo = true,
				test = true,
				tidy = true,
				upgrade_dependency = true,
				vendor = true,
			},
		},
	},
}
