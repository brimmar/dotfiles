return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				-- javascript = { "biome" },
				-- typescript = { "biome" },
				svelte = { "biome" },
				css = { "biome" },
				html = { "biome" },
				json = { "biome" },
				yaml = { "biome" },
				lua = { "stylua" },
				blade = { "blade-formatter" },
				-- php = { "pint" },
			},
			format_on_save = {
				-- lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			},
		})
	end,
}
