return {
	"numToStr/Comment.nvim",
	config = function()
		local comment = require("Comment")
		comment.setup({
			padding = true,
			sticky = true,
			ignore = "^$",
			mappings = {
				basic = true,
				extra = true,
			},
			toggler = {
				line = "gcc",
				block = "gbc",
			},
			opleader = {
				line = "gc",
				block = "gb",
			},
			extra = {
				above = "gcO",
				below = "gco",
				eol = "gcA",
			},
			pre_hook = function(...)
				local loaded, ts_comment = pcall(require, "ts_context_commentstring.integration.comment_nvim")
				if loaded and ts_comment then
					return ts_comment.create_pre_hook()(...)
				end
			end,
			post_hook = function() end,
		})
	end,
	keys = { { "gc", mode = { "n", "v" } }, { "gb", mode = { "n", "v" } } },
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
}
