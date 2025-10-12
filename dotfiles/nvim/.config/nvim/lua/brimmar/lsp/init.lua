local M = {}

local servers = {
	"lua_ls",
	"ts_ls",
	"html",
	"cssls",
	"jsonls",
	"phpactor",
	"svelte",
	"yamlls",
	"gopls",
	"ansible",
	"astro",
	"bashls",
	"biome",
	"dockerls",
	"elixirls",
	"rust_analyzer",
	"tailwindcss",
	"volar",
	"zls",
	"jq-lsp",
}

local function setup_diagnostics()
	vim.diagnostic.config({
		virtual_text = true,
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "",
				[vim.diagnostic.severity.WARN] = "",
				[vim.diagnostic.severity.INFO] = "󰋽",
				[vim.diagnostic.severity.HINT] = "",
			},
			priority = 20,
		},
		update_in_insert = false,
		underline = true,
		severity_sort = true,
		float = {
			border = "rounded",
			source = true,
			header = "",
			prefix = "",
		},
		virtual_lines = { current_line = true },
	})
end

local function get_capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()

	local has_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if has_cmp_nvim_lsp then
		capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		capabilities.textDocument.completion.completionItem.preselectSupport = true
		capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
		capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
		capabilities.textDocument.completion.completionItem.deprecatedSupport = true
		capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
		capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
		capabilities.textDocument.completion.completionItem.resolveSupport = {
			properties = {
				"documentation",
				"detail",
				"additionalTextEdits",
			},
		}
	end

	return capabilities
end

function M.setup()
	print("Setting up LSP servers...")

	setup_diagnostics()

	local default_config = {
		capabilities = get_capabilities(),
		flags = {
			debounce_text_changes = 150,
		},
		on_attach = function(client, bufnr)
			vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })

			local has_cmp, _ = pcall(require, "cmp")
		if has_cmp then
				vim.lsp.completion.enable(true, client.id, bufnr, {
					autotrigger = false,
				})
			end
		end,
	}

	vim.lsp.config("*", default_config)

	local successfully_enabled = {}
	local failed_servers = {}

	for _, server_name in ipairs(servers) do
		print("Setting up " .. server_name .. "...")

		local has_config, server_config = pcall(require, "brimmar.lsp." .. server_name)

		if has_config and type(server_config) == "table" then
			server_config.capabilities = server_config.capabilities or get_capabilities()

			local config_ok, config_err = pcall(function()
				vim.lsp.config(server_name, server_config)
			end)

			if not config_ok then
				print("Failed to configure " .. server_name .. ": " .. tostring(config_err))
				table.insert(failed_servers, server_name .. " (config error: " .. tostring(config_err) .. ")")
				goto continue
			end

			local enable_ok, enable_err = pcall(vim.lsp.enable, server_name)

			if enable_ok then
				print(server_name .. " successfully enabled")
				table.insert(successfully_enabled, server_name)
			else
				print("Failed to enable " .. server_name .. ": " .. tostring(enable_err))
				table.insert(failed_servers, server_name .. " (enable error: " .. tostring(enable_err) .. ")")
			end
		else
			print("No config found for " .. server_name)
			table.insert(failed_servers, server_name .. " (no config found)")
		end

		::continue::
	end

	if #failed_servers > 0 then
		vim.notify("Failed to set up LSP servers: " .. table.concat(failed_servers, ", "), vim.log.levels.ERROR)
	end

	vim.api.nvim_create_autocmd({ "CursorMoved", "DiagnosticChanged" }, {
		group = vim.api.nvim_create_augroup("diagnostic_virt_text_hide", {}),
		callback = function(ev)
			local cursor_pos = vim.api.nvim_win_get_cursor(0)

			local lnum = cursor_pos[1] - 1

			local hidden_lnum = vim.b[ev.buf].diagnostic_hidden_lnum
			if hidden_lnum and hidden_lnum ~= lnum then
				vim.b[ev.buf].diagnostic_hidden_lnum = nil
				vim.diagnostic.show(nil, ev.buf)
			end

			for _, namespace in pairs(vim.diagnostic.get_namespaces()) do
				local ns_id = namespace.user_data.virt_text_ns
				if ns_id then
					local extmarks = vim.api.nvim_buf_get_extmarks(ev.buf, ns_id, { lnum, 0 }, { lnum, -1 }, {})
					for _, extmark in pairs(extmarks) do
						local id = extmark[1]
						vim.api.nvim_buf_del_extmark(ev.buf, ns_id, id)
					end

					if extmarks and not vim.b[ev.buf].diagnostic_hidden_lnum then
						vim.b[ev.buf].diagnostic_hidden_lnum = lnum
					end
				end
			end
		end,
	})
end

return M