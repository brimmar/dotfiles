return {
	"akinsho/bufferline.nvim",
	config = function()
		local function is_ft(b, ft)
			return vim.bo[b].filetype == ft
		end

		local function diagnostics_indicator(_, _, diagnostics, _)
			local result = {}
			local symbols = {
				error = "",
				warning = "",
				info = "",
			}
			for name, count in pairs(diagnostics) do
				if symbols[name] and count > 0 then
					table.insert(result, symbols[name] .. " " .. count)
				end
			end
			local result_str = table.concat(result, " ")
			return #result_str > 0 and result_str or ""
		end

		local function custom_filter(buf, buf_nums)
			local logs = vim.tbl_filter(function(b)
				return is_ft(b, "log")
			end, buf_nums or {})
			if vim.tbl_isempty(logs) then
				return true
			end
			local tab_num = vim.fn.tabpagenr()
			local last_tab = vim.fn.tabpagenr("$")
			local is_log = is_ft(buf, "log")
			if last_tab == 1 then
				return true
			end
			return (tab_num == last_tab and is_log) or (tab_num ~= last_tab and not is_log)
		end

		local bufferline = require("bufferline")
		vim.opt.showtabline = 2

		local function buf_kill(kill_command, bufnr, force)
			kill_command = kill_command or "bd"

			local bo = vim.bo
			local api = vim.api
			local fmt = string.format
			local fn = vim.fn

			if bufnr == 0 or bufnr == nil then
				bufnr = api.nvim_get_current_buf()
			end

			local bufname = api.nvim_buf_get_name(bufnr)

			if not force then
				local choice
				if bo[bufnr].modified then
					choice = fn.confirm(fmt([[Save changes to "%s"?]], bufname), "&Yes\n&No\n&Cancel")
					if choice == 1 then
						vim.api.nvim_buf_call(bufnr, function()
							vim.cmd("w")
						end)
					elseif choice == 2 then
						force = true
					else
						return
					end
				elseif api.nvim_get_option_value("buftype", {
					scope = "local",
				}) == "terminal" then
					choice = fn.confirm(fmt([[Close "%s"?]], bufname), "&Yes\n&No\n&Cancel")
					if choice == 1 then
						force = true
					else
						return
					end
				end
			end

			-- Get list of windows IDs with the buffer to close
			local windows = vim.tbl_filter(function(win)
				return api.nvim_win_get_buf(win) == bufnr
			end, api.nvim_list_wins())

			if force then
				kill_command = kill_command .. "!"
			end

			-- Get list of active buffers
			local buffers = vim.tbl_filter(function(buf)
				return api.nvim_buf_is_valid(buf) and bo[buf].buflisted
			end, api.nvim_list_bufs())

			if #buffers > 1 and #windows > 0 then
				for i, v in ipairs(buffers) do
					if v == bufnr then
						local prev_buf_idx = i == 1 and #buffers or (i - 1)
						local prev_buffer = buffers[prev_buf_idx]
						for _, win in ipairs(windows) do
							api.nvim_win_set_buf(win, prev_buffer)
						end
					end
				end
			end

			-- Check if buffer still exists, to ensure the target buffer wasn't killed
			-- due to options like bufhidden=wipe.
			if api.nvim_buf_is_valid(bufnr) and bo[bufnr].buflisted then
				vim.cmd(string.format("%s %d", kill_command, bufnr))
			end
		end

		local opts = vim.tbl_deep_extend("force", { force = true }, {})
		local func_buffer_kill = function()
			buf_kill("bd")
		end
		vim.api.nvim_create_user_command("BufferKill", func_buffer_kill, opts)

		bufferline.setup({
			options = {
				mode = "buffers",
				numbers = "none",
				close_command = function(bufnr)
					buf_kill("bd", bufnr, false)
				end,
				right_mouse_command = "vert sbuffer $d",
				left_mouse_command = "buffer $d",
				middle_mouse_command = nil,
				indicator = {
					icon = "▎",
					style = "icon",
				},
				name_formatter = function(buf)
					if buf.name:match("%.md") then
						return vim.fn.fnamemodify(buf.name, ":t:r")
					end
				end,
				max_name_length = 18,
				max_prefix_length = 15,
				truncate_names = true,
				tab_size = 18,
				diagnostics = "nvim_lsp",
				diagnostics_update_in_insert = false,
				diagnostics_indicator = diagnostics_indicator,
				custom_filter = custom_filter,
				offsets = {
					{
						filetype = "undotree",
						text = "Undotree",
						highlight = "PanelHeading",
						padding = 1,
					},
					{
						filetype = "NvimTree",
						text = "Explorer",
						highlight = "PanelHeading",
						padding = 1,
					},
					{
						filetype = "DiffviewFiles",
						text = "Diff View",
						hightlight = "PanelHeading",
						padding = 1,
					},
					{
						filetype = "flutterToolsOutline",
						text = "Flutter Outline",
						highlight = "PanelHeading",
					},
					{
						filetype = "lazy",
						text = "Lazy",
						highlight = "PanelHeading",
						padding = 1,
					},
				},
				color_icons = true,
				show_buffer_icons = true,
				show_buffer_close_icons = true,
				show_close_icon = false,
				show_tab_indicators = true,
				persist_buffer_sort = true,
				separator_style = "thin",
				enforce_regular_tabs = false,
				always_show_bufferline = false,
				hover = {
					enabled = false,
					delay = 200,
					reveal = { "close" },
				},
				sort_by = "id",
			},
			highlights = {
				background = {
					italic = true,
				},
				buffer_selected = {
					bold = true,
				},
			},
		})
	end,
	branch = "main",
}
