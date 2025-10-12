return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"debugloop/telescope-undo.nvim",
		"folke/todo-comments.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local transform_mod = require("telescope.actions.mt").transform_mod

		local trouble = require("trouble")
		local trouble_telescope = require("trouble.sources.telescope")

		local custom_actions = transform_mod({
			open_trouble_qflist = function(prompt_bufnr)
				trouble.toggle("quickfix")
			end,
		})

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = require("telescope.actions").move_selection_previous,
						["<C-j>"] = require("telescope.actions").move_selection_next,
						["<C-q>"] = function(bufnr)
							require("telescope.actions").send_selected_to_qflist(bufnr)
							require("telescope.actions").open_qflist(bufnr)
						end,
						["<C-t>"] = require("trouble.sources.telescope").open,
					},
				},
				file_ignore_patterns = {
					"node_modules",
					"vendor",
					".git",
					"%.jpg",
					"%.jpeg",
					"%.png",
					"%.gif",
					"%.webp",
					"%.svg",
					"%.pdf",
					"%.zip",
					"%.tar.gz",
					"%.rar",
					"%.iso",
					"%.bin",
					"%.exe",
					"%.dll",
					"%.so",
					"%.dylib",
					"%.class",
					"%.pyc",
					"%.o",
					"%.a",
					"package%-lock.json",
					"composer.lock",
					"yarn.lock",
					"pnpm-lock.yaml",
					"poetry.lock",
					"%.lock",
				},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("undo")
	end,
}
