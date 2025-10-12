return {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", "rust-project.json", ".git" },
	settings = {
		["rust-analyzer"] = {
			assist = {
				importGranularity = "module",
				importPrefix = "by_self",
			},
			cargo = {
				loadOutDirsFromCheck = true,
				allFeatures = true,
			},
			procMacro = {
				enable = true,
			},
			checkOnSave = {
				command = "clippy",
				allFeatures = true,
			},
			inlayHints = {
				lifetimeElisionHints = {
					enable = "always",
				},
				maxLength = 20,
				parameterHints = {
					enable = true,
				},
				reborrowHints = {
					enable = "always",
				},
				typeHints = {
					enable = true,
				},
			},
		},
	},
}
