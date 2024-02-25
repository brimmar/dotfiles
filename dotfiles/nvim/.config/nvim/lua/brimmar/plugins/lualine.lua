return {
	"nvim-lualine/lualine.nvim",
	config = function()
		local lualine = require("lualine")
		-- flag pra saber se vai usar icons ou não
		local use_icons = true
		local icons = {
			kind = {
				Array = "",
				Boolean = "",
				Class = "",
				Color = "",
				Constant = "",
				Constructor = "",
				Enum = "",
				EnumMember = "",
				Event = "",
				Field = "",
				File = "",
				Folder = "󰉋",
				Function = "",
				Interface = "",
				Key = "",
				Keyword = "",
				Method = "",
				Module = "",
				Namespace = "",
				Null = "󰟢",
				Number = "",
				Object = "",
				Operator = "",
				Package = "",
				Property = "",
				Reference = "",
				-- TODO: Esse icon ta quebrado
				Snippet = "",
				String = "",
				Struct = "",
				Text = "",
				TypeParameter = "",
				Unit = "",
				Value = "",
				Variable = "",
			},
			git = {
				LineAdded = "",
				LineModified = "",
				LineRemoved = "",
				FileDeleted = "",
				FileIgnored = "◌",
				FileRenamed = "",
				FileStaged = "S",
				FileUnmerged = "",
				FileUnstaged = "",
				FileUntracked = "U",
				Diff = "",
				Repo = "",
				Octoface = "",
				Branch = "",
			},
			ui = {
				ArrowCircleDown = "",
				ArrowCircleLeft = "",
				ArrowCircleRight = "",
				ArrowCircleUp = "",
				BoldArrowDown = "",
				BoldArrowLeft = "",
				BoldArrowRight = "",
				BoldArrowUp = "",
				BoldClose = "",
				BoldDividerLeft = "",
				BoldDividerRight = "",
				BoldLineLeft = "▎",
				BookMark = "",
				BoxChecked = "",
				Bug = "",
				Stacks = "",
				Scopes = "",
				Watches = "󰂥",
				DebugConsole = "",
				Calendar = "",
				Check = "",
				ChevronRight = "",
				ChevronShortDown = "",
				ChevronShortLeft = "",
				ChevronShortRight = "",
				ChevronShortUp = "",
				Circle = " ",
				Close = "󰅖",
				CloudDownload = "",
				Code = "",
				Comment = "",
				Dashboard = "",
				DividerLeft = "",
				DividerRight = "",
				DoubleChevronRight = "»",
				Ellipsis = "",
				EmptyFolder = "",
				EmptyFolderOpen = "",
				File = "",
				FileSymlink = "",
				Files = "",
				FindFile = "󰈞",
				FindText = "󰊄",
				Fire = "",
				Folder = "󰉋",
				FolderOpen = "",
				FolderSymlink = "",
				Forward = "",
				Gear = "",
				History = "",
				Lightbulb = "",
				LineLeft = "▏",
				LineMiddle = "│",
				List = "",
				Lock = "",
				NewFile = "",
				Note = "",
				Package = "",
				Pencil = "󰏫",
				Plus = "",
				Project = "",
				Search = "",
				SignIn = "",
				SignOut = "",
				Tab = "󰌒",
				Table = "",
				Target = "󰀘",
				Telescope = "",
				Text = "",
				Tree = "",
				Triangle = "󰐊",
				TriangleShortArrowDown = "",
				TriangleShortArrowLeft = "",
				TriangleShortArrowRight = "",
				TriangleShortArrowUp = "",
			},
			diagnostics = {
				BoldError = "",
				Error = "",
				BoldWarning = "",
				Warning = "",
				BoldInformation = "",
				Information = "",
				BoldQuestion = "",
				Question = "",
				BoldHint = "",
				Hint = "󰌶",
				Debug = "",
				Trace = "✎",
			},
			misc = {
				Robot = "󰚩",
				Squirrel = "",
				Tag = "",
				Watch = "",
				Smiley = "",
				Package = "",
				CircuitBoard = "",
			},
		}
		local branch = icons.git.Branch
		local window_width_limit = 100
		local conditions = {
			buffer_not_empty = function()
				return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
			end,
			hide_in_width = function()
				return vim.o.columns > window_width_limit
			end,
		}
		local colors = {
			bg = "#202328",
			fg = "#bbc2cf",
			yellow = "#ECBE7B",
			cyan = "#008080",
			darkblue = "#081633",
			green = "#98be65",
			orange = "#FF8800",
			violet = "#a9a1e1",
			magenta = "#c678dd",
			purple = "#c678dd",
			blue = "#51afef",
			red = "#ec5f67",
		}
		local colorscheme = "onedark"
		local function diff_source()
			local gitsigns = vim.b.gitsigns_status_dict
			if gitsigns then
				return {
					added = gitsigns.added,
					modified = gitsigns.changed,
					removed = gitsigns.removed,
				}
			end
		end
		local components = {
			mode = {
				function()
					return " " .. icons.ui.Target .. " "
				end,
				padding = { left = 0, right = 0 },
				color = {},
				cond = nil,
			},
			branch = {
				"b:gitsigns_head",
				icon = branch,
				color = { gui = "bold" },
			},
			filename = {
				"filename",
				color = {},
				cond = nil,
			},
			diff = {
				"diff",
				source = diff_source,
				symbols = {
					added = icons.git.LineAdded .. " ",
					modified = icons.git.LineModified .. " ",
					removed = icons.git.LineRemoved .. " ",
				},
				padding = { left = 2, right = 1 },
				diff_color = {
					added = { fg = colors.green },
					modified = { fg = colors.yellow },
					removed = { fg = colors.red },
				},
				cond = nil,
			},
			diagnostics = {
				"diagnostics",
				sources = { "nvim_diagnostic" },
				symbols = {
					error = icons.diagnostics.BoldError .. " ",
					warn = icons.diagnostics.BoldWarning .. " ",
					info = icons.diagnostics.BoldInformation .. " ",
					hint = icons.diagnostics.BoldHint .. " ",
				},
			},
			treesitter = {
				function()
					return icons.ui.Tree
				end,
				color = function()
					local buf = vim.api.nvim_get_current_buf()
					local ts = vim.treesitter.highlighter.active[buf]
					return { fg = ts and not vim.tbl_isempty(ts) and colors.green or colors.red }
				end,
				cond = conditions.hide_in_width,
			},
			lsp = {
				function()
					local buf_clients = vim.lsp.get_active_clients({ bufnr = 0 })
					if #buf_clients == 0 then
						return "LSP Inactive"
					end

					local buf_ft = vim.bo.filetype
					local buf_client_names = {}

					-- add client
					for _, client in pairs(buf_clients) do
						if client.name ~= "null-ls" and client.name ~= "copilot" then
							table.insert(buf_client_names, client.name)
						end
					end

					local unique_client_names = table.concat(buf_client_names, ", ")
					local language_servers = string.format("[%s]", unique_client_names)

					return language_servers
				end,
				color = { gui = "bold" },
				cond = conditions.hide_in_width,
			},
			location = { "location" },
			progress = {
				"progress",
				fmt = function()
					return "%P/%L"
				end,
				color = {},
			},
			spaces = {
				function()
					local shiftwidth = vim.api.nvim_buf_get_option(0, "shiftwidth")
					return icons.ui.Tab .. " " .. shiftwidth
				end,
				padding = 1,
			},
			encoding = {
				"o:encoding",
				fmt = string.upper,
				color = {},
				cond = conditions.hide_in_width,
			},
			filetype = { "filetype", cond = nil, padding = { left = 1, right = 1 } },
			scrollbar = {
				function()
					local current_line = vim.fn.line(".")
					local total_lines = vim.fn.line("$")
					local chars =
						{ "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
					local line_ratio = current_line / total_lines
					local index = math.ceil(line_ratio * #chars)
					return chars[index]
				end,
				padding = { left = 0, right = 0 },
				color = "SLProgress",
				cond = nil,
			},
		}
		local styles = {
			lvim = nil,
			default = nil,
			none = nil,
		}

		if #vim.api.nvim_list_uis() == 0 then
			return
		end

		styles.lvim = {
			style = "lvim",
			options = {
				theme = "auto",
				globalstatus = true,
				icons_enabled = use_icons,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = { "alpha" },
			},
			sections = {
				lualine_a = {
					components.mode,
				},
				lualine_b = {
					components.branch,
				},
				lualine_c = {
					components.diff,
					components.python_env,
				},
				lualine_x = {
					components.diagnostics,
					components.lsp,
					components.spaces,
					components.filetype,
				},
				lualine_y = {
					components.location,
				},
				lualine_z = {
					components.progress,
				},
			},
			inactive_sections = {
				lualine_a = {
					components.mode,
				},
				lualine_b = {
					components.branch,
				},
				lualine_c = {
					components.diff,
					components.python_env,
				},
				lualine_x = {
					components.diagnostics,
					components.lsp,
					components.spaces,
					components.filetype,
				},
				lualine_y = {
					components.location,
				},
				lualine_z = {
					components.progress,
				},
			},
			tabline = {},
			extensions = {},
		}

		local style = function(style)
			local style_keys = vim.tbl_keys(styles)
			if not vim.tbl_contains(style_keys, style) then
				style = "lvim"
			end
			return vim.deepcopy(styles[style])
		end

		local color_template = vim.g.colors_name or colorscheme
		pcall(function()
			require("lualine.utils.loader").load_theme(color_template)
		end)

		lualine.setup(style(styles.lvim))
	end,
}
