return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")

		mason.setup({
			ui = {
				icons = {
					package_installed = "◍",
					package_pending = "◍",
					package_unistalled = "◍",
				},
			},
		})

		mason_lspconfig.setup({
			ensure_installed = {
				"intelephense",
				"tsserver",
				"html",
				"cssls",
				"jsonls",
				"tailwindcss",
				"bashls",
				"svelte",
				"lua_ls",
				"emmet_ls",
				"dockerls",
				"yamlls",
				"rust_analyzer",
				"ansiblels",
				"astro",
				"elixirls",
				"volar",
			},
			automatic_installation = true,
		})
	end,
}
