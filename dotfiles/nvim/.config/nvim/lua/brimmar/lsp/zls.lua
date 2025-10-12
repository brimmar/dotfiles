return {
	cmd = { "zls" },
	filetypes = { "zig", "zir" },
	root_markers = { "build.zig", ".git" },
	single_file_support = true,
	settings = {
		zls = {
			enable_autofix = true,
			enable_build_on_save = true,
			warn_style = true,
			enable_imports_insertion = true,
			enable_snippets = true,
			semantic_tokens = true,
			enable_inlay_hints = true,
			inlay_hints_show_builtin = true,
			inlay_hints_show_parameter_name = true,
			inlay_hints_show_variable_type = true,
			inlay_hints_hide_redundant_param_names = false,
			inlay_hints_hide_redundant_param_names_last_token = false,
			operator_completions = true,
		},
	},
}
