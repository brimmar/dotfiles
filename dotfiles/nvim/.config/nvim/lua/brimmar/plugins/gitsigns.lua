return {
	"lewis6991/gitsigns.nvim",
	config = function()
		local gitsigns = require("gitsigns")

		vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#7BC47F" })
		vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#80B1DB" })
		vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#DB7F7F" })
		vim.api.nvim_set_hl(0, "GitSignsTopdelete", { fg = "#DB7F7F" })
		vim.api.nvim_set_hl(0, "GitSignsChangedelete", { fg = "#B87FDB" })

		vim.api.nvim_set_hl(0, "GitSignsAddNr", { fg = "#7BC47F" })
		vim.api.nvim_set_hl(0, "GitSignsChangeNr", { fg = "#80B1DB" })
		vim.api.nvim_set_hl(0, "GitSignsDeleteNr", { fg = "#DB7F7F" })
		vim.api.nvim_set_hl(0, "GitSignsTopdeleteNr", { fg = "#DB7F7F" })
		vim.api.nvim_set_hl(0, "GitSignsChangedeleteNr", { fg = "#B87FDB" })

		vim.api.nvim_set_hl(0, "GitSignsAddLn", { fg = "#7BC47F" })
		vim.api.nvim_set_hl(0, "GitSignsChangeLn", { fg = "#80B1DB" })
		vim.api.nvim_set_hl(0, "GitSignsDeleteLn", { fg = "#DB7F7F" })
		vim.api.nvim_set_hl(0, "GitSignsTopdeleteLn", { fg = "#DB7F7F" })
		vim.api.nvim_set_hl(0, "GitSignsChangedeleteLn", { fg = "#B87FDB" })

		gitsigns.setup({
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = nil },
				topdelete = { text = nil },
				changedelete = { text = nil },
				untracked = { text = "┆" },
			},
			sign_priority = 20,
			signcolumn = true,
			numhl = false,
			linehl = false,
			word_diff = false,
			watch_gitdir = {
				interval = 1000,
				follow_files = true,
			},
			attach_to_untracked = true,
			current_line_blame = false,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol",
				delay = 1000,
				ignore_whitespace = false,
			},
			current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
			update_debounce = 200,
			max_file_length = 40000,
			preview_config = {
				border = "rounded",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
		})
	end,
	event = { "BufReadPre", "BufNewFile" },
	cmd = "Gitsigns",
}
