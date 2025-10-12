return {
	cmd = { "astro-ls", "--stdio" },
	filetypes = { "astro" },
	root_markers = { "package.json", "astro.config.mjs", "astro.config.js", "astro.config.ts", ".git" },
	init_options = {
		typescript = {
			tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib",
		},
	},
	settings = {}, -- This can be left empty or removed
}
