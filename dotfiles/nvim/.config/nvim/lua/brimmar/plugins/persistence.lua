return {
	"folke/persistence.nvim",
	event = "VimEnter",
	opts = {
		dir = vim.fn.stdpath("state") .. "/sessions/",
		need = 1,
		branch = true,
	},
	config = function(_, opts)
		require("persistence").setup(opts)

		vim.api.nvim_create_autocmd("VimEnter", {
			desc = "Auto-load session when opening Neovim in a directory",
			callback = function()
				if vim.fn.argc() > 0 then
					return
				end

				if vim.fn.isdirectory(".git") == 1 then
					require("persistence").load()
				end
			end,
			nested = true,
			once = true,
		})
	end,
}
