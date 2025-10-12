return {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml", "yaml.docker-compose" },
	root_markers = { ".git" },
	settings = {
		yaml = {
			schemas = {
				["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
				["https://json.schemastore.org/github-action.json"] = "/.github/actions/*/action.yml",
				["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.yml",
			},
			format = {
				enable = true,
			},
			validate = true,
		},
	},
}
