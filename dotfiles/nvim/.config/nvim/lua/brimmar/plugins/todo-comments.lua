return {
	"folke/todo-comments.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"folke/trouble.nvim",
	},
	config = function()
		local todo = require("todo-comments")
		todo.setup()
	end,
	event = { "BufReadPre", "BufNewFile" },
}
