return {
	"lukas-reineke/indent-blankline.nvim",
	config = function()
		local ib = require("ibl")
		local hooks = require("ibl.hooks")

		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#4D3434" })
			vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#4C4D37" })
			vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#303B4D" })
			vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#4D4032" })
			vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#3D4D39" })
			vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#39354D" })
			vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#2F4A4D" })
		end)

		ib.setup({
			enabled = true,
			indent = {
				highlight = {
					"RainbowRed",
					"RainbowYellow",
					"RainbowBlue",
					"RainbowOrange",
					"RainbowGreen",
					"RainbowViolet",
					"RainbowCyan",
				},
				char = "▏",
			},
			exclude = {
				buftypes = { "terminal", "nofile" },
				filetypes = { "help", "startify", "dashboard", "lazy", "neogitstatus", "NvimTree", "Trouble", "text" },
			},
			scope = {
				enabled = false,
			},
		})
	end,
	event = { "BufReadPre", "BufNewFile" },
}
