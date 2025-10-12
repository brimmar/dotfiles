return {
	cmd = { "ansible-language-server", "--stdio" },
	filetypes = { "yaml.ansible", "ansible" },
	root_markers = { "ansible.cfg", ".ansible-lint", ".git" },
	settings = {
		ansible = {
			ansible = {
				path = "ansible",
			},
			executionEnvironment = {
				enabled = false,
			},
			python = {
				interpreterPath = "python",
			},
			validation = {
				enabled = true,
				lint = {
					enabled = true,
					path = "ansible-lint",
				},
			},
		},
	},
	on_attach = function(client, bufnr)
		vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
			pattern = {
				"*/playbooks/*.yml",
				"*/roles/*.yml",
				"*/inventory/*.yml",
				"*/host_vars/*.yml",
				"*/group_vars/*.yml",
			},
			callback = function()
				vim.bo.filetype = "yaml.ansible"
			end,
		})
	end,
}
