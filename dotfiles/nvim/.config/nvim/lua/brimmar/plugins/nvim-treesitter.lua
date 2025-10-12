return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPre", "BufNewFile" },
	cmd = {
		"TSInstall",
		"TSUninstall",
		"TSUpdate",
		"TSUpdateSync",
		"TSInstallInfo",
		"TSInstallSync",
		"TSInstallFromGrammar",
	},
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function()
		local treesitter = require("nvim-treesitter.configs")
		local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

		parser_config.blade = {
			install_info = {
				url = "https://github.com/EmranMR/tree-sitter-blade",
				files = { "src/parser.c" },
				branch = "main",
			},
			filetype = "blade",
		}

		treesitter.setup({
			highlight = {
				enable = true,
			},

			injection = {
				enable = true,
			},

			ensure_installed = {
				"json",
				"javascript",
				"typescript",
				"yaml",
				"html",
				"css",
				"markdown",
				"markdown_inline",
				"svelte",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"vimdoc",
				"prisma",
				"go",
				"gitcommit",
				"bash",
				"scss",
				"kdl",
				"r",
				"rust",
				"toml",
				"xml",
				"vue",
				"php",
				"phpdoc",
				"php_only",
				"blade",
			},

			auto_install = false,

			sync_install = false,

			ignore_install = {},

			indent = { enable = true },

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})
	end,
}
