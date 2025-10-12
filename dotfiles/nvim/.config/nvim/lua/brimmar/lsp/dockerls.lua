return {
	cmd = { "dockerfile-language-server", "--stdio" },
	filetypes = { "dockerfile" },
	root_markers = { "Dockerfile", "docker-compose.yml", "docker-compose.yaml", ".git" },
	single_file_support = true,
	settings = {
		docker = {
			languageserver = {
				diagnostics = {
					enable = true,
					deprecatedMaintainer = true,
					directiveCasing = true,
					emptyContinuationLine = true,
					instructionCasing = true,
					instructionCmdMultiple = true,
					instructionEntrypointMultiple = true,
					instructionHealthcheckMultiple = true,
					instructionJSONInSingleQuotes = true,
				},
				formatter = {
					enable = true,
				},
			},
		},
	},
}
