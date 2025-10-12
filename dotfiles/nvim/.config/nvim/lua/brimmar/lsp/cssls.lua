return {
	cmd = { "vscode-css-language-server", "--stdio" },
	filetypes = { "css", "scss", "less" },
	root_markers = { ".git", "package.json" },
	settings = {
		css = {
			validate = true,
			lint = {
				unknownAtRules = "ignore",
			},
		},
		scss = {
			validate = true,
			lint = {
				unknownAtRules = "ignore",
			},
		},
		less = {
			validate = true,
			lint = {
				unknownAtRules = "ignore",
			},
		},
	},
}
