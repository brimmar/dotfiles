return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"whoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

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
				"tsserver",
				"html",
				"cssls",
				"jsonls",
				"tailwindcss",
				"bashls",
				"svelte",
				"lua_ls",
				"dockerls",
				"yamlls",
				"rust_analyzer",
				"ansiblels",
				"astro",
				"elixirls",
				"volar",
				"biome",
				"phpactor",
				"psalm",
				"gopls",
			},
			automatic_installation = true,
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"stylua",
				"phpstan",
				"pint",
			},
		})
	end,
}
