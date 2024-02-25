return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		local autopairs = require("nvim-autopairs")

		autopairs.setup({
			check_ts = true,
			enable_check_bracket_line = false,
			ts_config = {
				lua = { "string", "source" },
				javascript = { "string", "template_string" },
				java = false,
			},
			disable_filetype = { "TelescopePrompt", "spectre_panel" },
			ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
			enable_moveright = true,
			disable_in_macro = false,
			enable_afterquote = true,
			map_bs = true,
			map_c_w = false,
			disable_in_visualblock = false,
			fast_wrap = {
				map = "<M-e>",
				chars = { "{", "[", "(", '"', "'" },
				pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
				offset = 0,
				end_key = "$",
				keys = "qwertyuiopzxcvbnmasdfghjkl",
				check_comma = true,
				highlight = "Search",
				highlight_grey = "Comment",
			},
		})

		pcall(function()
			local function on_confirm_done(...)
				require("nvim-autopairs.completion.cmp").on_confirm_done()(...)
			end
			require("cmp").event:off("confirm_done", on_confirm_done)
			require("cmp").event:on("confirm_done", on_confirm_done)
		end)
	end,
	dependencies = { "nvim-treesitter/nvim-treesitter", "hrsh7th/nvim-cmp" },
}
