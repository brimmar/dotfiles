return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")

		require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/brimmar/plugins/snippets/" })

		local types = require("luasnip.util.types")
		luasnip.config.set_config({
			history = true,
			updateevents = "TextChanged,TextChangedI",
			enable_autosnippets = true,
			ext_opts = {
				[types.choiceNode] = {
					active = {
						virt_text = { { ".", "GruvboxOrange" } },
					},
				},
			},
		})

		local keymap = vim.keymap

		keymap.set({ "i", "s" }, "<a-k>", function()
			if luasnip.jumpable(1) then
				luasnip.jump(1)
			end
		end, { silent = true })
		keymap.set({ "i", "s" }, "<a-j>", function()
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			end
		end, { silent = true })
		keymap.set({ "i", "s" }, "<a-l>", function()
			if luasnip.choice_active() then
				luasnip.change_choice(1)
			else
				--print current line
				local t = os.date("*t")
				local time = string.format("%02d:%02d:%02d", t.hour, t.min, t.sec)
				print(time)
			end
		end)
		keymap.set({ "i", "s" }, "<a-h>", function()
			if luasnip.choice_active() then
				luasnip.change_choice(-1)
			end
		end)

		cmp.setup({
			completion = {
				completeopt = "menu,menuone, preview, noselect",
			},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(),
				["<C-j>"] = cmp.mapping.select_next_item(),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = false }),
			}),
			sources = cmp.config.sources({
				{ name = "luasnip", max_item_count = 2 },
				{ name = "nvim_lsp", max_item_count = 6 },
				{ name = "path" },
				{ name = "buffer", max_item_count = 4 },
			}),
		})
	end,
}
