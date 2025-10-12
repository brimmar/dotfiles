return {
	"williamboman/mason.nvim",
	dependencies = {
		"whoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_tool_installer = require("mason-tool-installer")

		mason.setup({
			ui = {
				icons = {
					package_installed = "◍",
					package_pending = "◍",
					package_uninstalled = "◍",
				},
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				-- Other Tools
				"stylua",
				"phpstan",
				"pint",

				-- LSPs
				"ansible-language-server",
				"astro-language-server",
				"bash-language-server",
				"biome",
				"css-lsp",
				"dockerfile-language-server",
				"elixir-ls",
				"gopls",
				"html-lsp",
				"json-lsp",
				"lua-language-server",
				"phpactor",
				"rust-analyzer",
				"svelte-language-server",
				"tailwindcss-language-server",
				"typescript-language-server",
				"vue-language-server",
				"yaml-language-server",
				"zls",
			},
		})
	end,
}
