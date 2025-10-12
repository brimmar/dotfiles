return {
	cmd = { "svelte-language-server", "--stdio" },
	filetypes = { "svelte" },
	root_markers = { "package.json", "svelte.config.js", ".git" },
	settings = {
		svelte = {
			plugin = {
				html = {
					completions = {
						enable = true,
						emmet = true,
					},
				},
				svelte = {
					completions = {
						enable = true,
					},
				},
				css = {
					completions = {
						enable = true,
						emmet = true,
					},
				},
			},
		},
	},
	on_attach = function(client, bufnr)
		vim.api.nvim_create_autocmd("BufWritePost", {
			pattern = { "*.js", "*.ts" },
			callback = function(ctx)
				client:notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
			end,
		})
	end,
}
