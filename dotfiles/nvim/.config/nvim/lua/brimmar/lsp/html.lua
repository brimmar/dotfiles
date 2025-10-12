return {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html", "blade" },
	root_markers = { ".git", "package.json" },
	init_options = {
		configurationSection = { "html", "css", "javascript" },
		embeddedLanguages = {
			css = true,
			javascript = true,
		},
		provideFormatter = true,
	},
	settings = {
		html = {
			format = {
				indentInnerHtml = false,
				wrapLineLength = 100,
				wrapAttributes = "auto",
			},
			suggest = {
				html5 = true,
			},
			validate = {
				scripts = true,
				styles = true,
			},
		},
	},
}
