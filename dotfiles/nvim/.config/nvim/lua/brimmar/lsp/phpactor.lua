return {
	cmd = { "phpactor", "language-server" },
	filetypes = { "php", "blade" },
	root_markers = { "composer.json", ".git" },
	init_options = {
		["language_server_phpstan.enabled"] = true,
		["language_server_psalm.enabled"] = false,
	},
	settings = {
		phpactor = {
			completion = {
				enableSnippets = true,
				enableDetailedLabel = true,
			},
			indexer = {
				excludePaths = {
					"vendor/**/*",
					"node_modules/**/*",
					"var/cache/**/*",
				},
			},
		},
	},
}
