return {
	cmd = { "bash-language-server", "start" },
	filetypes = { "sh", "bash", "zsh" },
	root_markers = { ".git", ".bashrc", ".zshrc" },
	settings = {
		bashIde = {
			globPattern = "*@(.sh|.inc|.bash|.command|.zsh)",
			shellcheckPath = "shellcheck",
			enableSourceErrorDiagnostics = true,
		},
	},
}
