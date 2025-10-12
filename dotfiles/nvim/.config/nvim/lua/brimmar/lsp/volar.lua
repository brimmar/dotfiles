return {
	cmd = { "vue-language-server", "--stdio" },
	filetypes = { "vue" },
	root_markers = { "package.json", "vue.config.js", "nuxt.config.js", "nuxt.config.ts", ".git" },
	init_options = {
		typescript = {
			tsdk = "",
		},
		vue = {
			hybridMode = true,
		},
	},
	settings = {
		volar = {
			autoCompleteRefs = true,
			codeLens = {
				references = true,
				pugTools = true,
				scriptSetupTools = true,
			},
			completion = {
				autoImportComponent = true,
				preferredTagNameCase = "kebab",
				preferredAttrNameCase = "kebab",
			},
			diagnostics = {
				delay = 200,
			},
			icon = {
				preview = true,
			},
			smalledit = {
				enable = true,
			},
			update = {
				tsconfigPath = "tsconfig.json",
			},
			verification = {
				templateCheck = true,
				scriptCheck = true,
				stylesCheck = true,
			},
		},
	},
}
