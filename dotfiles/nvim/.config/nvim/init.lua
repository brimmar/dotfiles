require("brimmar.core")
require("brimmar.lazy")

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.defer_fn(function()
			require("brimmar.lsp").setup()
		end, 1000)
	end,
	once = true,
})

vim.api.nvim_create_user_command("SetupLSP", function()
	require("brimmar.lsp").setup()
end, {})
