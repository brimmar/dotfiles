return {
	cmd = { "elixir-ls" },
	filetypes = { "elixir", "eelixir", "heex" },
	root_markers = { "mix.exs", ".git" },
	settings = {
		elixirLS = {
			dialyzerEnabled = true,
			dialyzerFormat = "dialyxir_short",
			fetchDeps = true,
			enableTestLenses = true,
			suggestSpecs = true,
		},
	},
}
