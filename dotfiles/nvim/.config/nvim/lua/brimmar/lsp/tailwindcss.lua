return {
	cmd = { "tailwindcss-language-server", "--stdio" },
	filetypes = {
		"html",
		"css",
		"scss",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"svelte",
		"vue",
		"blade",
		"astro",
	},
	root_markers = {
		"tailwind.config.js",
		"tailwind.config.cjs",
		"tailwind.config.mjs",
		"tailwind.config.ts",
		"postcss.config.js",
		"postcss.config.cjs",
		"postcss.config.mjs",
		"postcss.config.ts",
		".git",
	},
	init_options = {
		userLanguages = {
			blade = "html",
		},
	},
	settings = {
		tailwindCSS = {
			classAttributes = { "class", "className", "classList", "ngClass", "x-bind:class" },
			lint = {
				cssConflict = "warning",
				invalidApply = "error",
				invalidConfigPath = "error",
				invalidScreen = "error",
				invalidTailwindDirective = "error",
				invalidVariant = "error",
				recommendedVariantOrder = "warning",
			},
			validate = true,
			experimental = {
				classRegex = {
					"\\bclass\\s*=\\s*['\"]([^'\"]*)['\"]",
					"\\bclassName\\s*=\\s*['\"]([^'\"]*)['\"]",
					"\\btw\\s*`([^`]*)`",
				},
			},
		},
	},
}
