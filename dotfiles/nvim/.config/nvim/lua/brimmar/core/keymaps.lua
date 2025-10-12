local modes = {
	insert = "i",
	normal = "n",
	term = "t",
	visual = "v",
	visual_block = "x",
	command = "c",
	operator_pending = "o",
}

vim.g.mapleader = " "

local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

-- Window navigation
map(modes.normal, "<C-h>", "<C-w>h", { desc = "Move left one window" })
map(modes.normal, "<C-j>", "<C-w>j", { desc = "Move down one window" })
map(modes.normal, "<C-k>", "<C-w>k", { desc = "Move up one window" })
map(modes.normal, "<C-l>", "<C-w>l", { desc = "Move right one window" })

-- Window resizing
map(modes.normal, "<C-Up>", ":resize -2<CR>", { desc = "Resize window up" })
map(modes.normal, "<C-Down>", ":resize +2<CR>", { desc = "Resize window down" })
map(modes.normal, "<C-Left>", ":vertical resize -2<CR>", { desc = "Resize window left" })
map(modes.normal, "<C-Right>", ":vertical resize +2<CR>", { desc = "Resize window right" })

-- Indenting
map(modes.visual, "<", "<gv", { desc = "Indent line to the left" })
map(modes.visual, ">", ">gv", { desc = "Indent line to the right" })

-- Moving code blocks
map(modes.visual_block, "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move code block down" })
map(modes.visual_block, "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move code block up" })

-- General
map(modes.normal, "<leader>;", "<cmd>Alpha<CR>", { desc = "Dashboard" })
map(modes.normal, "<leader>/", "<Plug>(comment_toggle_linewise_current)", { desc = "Comment toggle current line" })
map(modes.visual, "<leader>/", "<Plug>(comment_toggle_linewise_visual)", { desc = "Comment toggle linewise (visual)" })
map(modes.normal, "<leader>c", "<cmd>BufferKill<CR>", { desc = "Close Buffer" })
map(modes.normal, "<leader>h", "<cmd>nohlsearch<CR>", { desc = "No Highlight" })
map(modes.normal, "<leader>e", "<cmd>Ex<CR>", { desc = "Explorer" })

-- Buffers
map(modes.normal, "<leader>bj", "<cmd>BufferLinePick<cr>", { desc = "Jump to buffer" })
map(modes.normal, "<leader>bf", "<cmd>Telescope buffers previewer=false<cr>", { desc = "Find buffer" })
map(modes.normal, "<leader>bb", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer" })
map(modes.normal, "<leader>bn", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
map(modes.normal, "<leader>bW", "<cmd>noautocmd w<cr>", { desc = "Save without formatting (noautocmd)" })
map(modes.normal, "<leader>be", "<cmd>BufferLinePickClose<cr>", { desc = "Pick which buffer to close" })
map(modes.normal, "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", { desc = "Close all to the left" })
map(modes.normal, "<leader>bl", "<cmd>BufferLineCloseRight<cr>", { desc = "Close all to the right" })
map(modes.normal, "<leader>bD", "<cmd>BufferLineSortByDirectory<cr>", { desc = "Sort by directory" })
map(modes.normal, "<leader>bL", "<cmd>BufferLineSortByExtension<cr>", { desc = "Sort by language" })

-- Plugins management
map(modes.normal, "<leader>pi", "<cmd>Lazy install<cr>", { desc = "Install plugins" })
map(modes.normal, "<leader>ps", "<cmd>Lazy sync<cr>", { desc = "Sync plugins" })
map(modes.normal, "<leader>pS", "<cmd>Lazy clear<cr>", { desc = "Show plugin status" })
map(modes.normal, "<leader>pc", "<cmd>Lazy clean<cr>", { desc = "Clean plugins" })
map(modes.normal, "<leader>pu", "<cmd>Lazy update<cr>", { desc = "Update plugins" })
map(modes.normal, "<leader>pp", "<cmd>Lazy profile<cr>", { desc = "Profile plugins" })
map(modes.normal, "<leader>pl", "<cmd>Lazy log<cr>", { desc = "Plugin logs" })
map(modes.normal, "<leader>pd", "<cmd>Lazy debug<cr>", { desc = "Debug plugins" })

-- Git operations
map(modes.normal, "<leader>gj", function()
	require("gitsigns").next_hunk({ navigation_message = false })
end, { desc = "Next git hunk" })
map(modes.normal, "<leader>gk", function()
	require("gitsigns").prev_hunk({ navigation_message = false })
end, { desc = "Previous git hunk" })
map(modes.normal, "<leader>gl", function()
	require("gitsigns").blame_line()
end, { desc = "View git blame" })
map(modes.normal, "<leader>gp", function()
	require("gitsigns").preview_hunk()
end, { desc = "Preview git hunk" })
map(modes.normal, "<leader>gr", function()
	require("gitsigns").reset_hunk()
end, { desc = "Reset git hunk" })
map(modes.normal, "<leader>gR", function()
	require("gitsigns").reset_buffer()
end, { desc = "Reset git buffer" })
map(modes.normal, "<leader>gs", function()
	require("gitsigns").stage_hunk()
end, { desc = "Stage git hunk" })
map(modes.normal, "<leader>gu", function()
	require("gitsigns").undo_stage_hunk()
end, { desc = "Undo stage git hunk" })
map(modes.normal, "<leader>go", "<cmd>Telescope git_status<cr>", { desc = "Git status" })
map(modes.normal, "<leader>gb", "<cmd>Telescope git_branches<cr>", { desc = "Git branches" })
map(modes.normal, "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Git commits" })
map(modes.normal, "<leader>gC", "<cmd>Telescope git_bcommits<cr>", { desc = "Git buffer commits" })
map(modes.normal, "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", { desc = "Git diff" })

-- LSP actions
map(modes.normal, "<leader>la", function()
	vim.lsp.buf.code_action()
end, { desc = "Code action" })
map(modes.visual, "<leader>la", function()
	vim.lsp.buf.code_action()
end, { desc = "Code action" })
map(modes.normal, "<leader>ld", "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>", { desc = "Buffer diagnostics" })
map(modes.normal, "<leader>lw", "<cmd>Telescope diagnostics<cr>", { desc = "Workspace diagnostics" })
map(modes.normal, "<leader>lI", "<cmd>Mason<cr>", { desc = "Mason info" })
map(modes.normal, "<leader>lj", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
map(modes.normal, "<leader>lk", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous diagnostic" })
map(modes.normal, "<leader>ll", function()
	vim.lsp.codelens.run()
end, { desc = "CodeLens action" })
map(modes.normal, "<leader>lq", function()
	vim.diagnostic.setloclist()
end, { desc = "Set location list" })
map(modes.normal, "<leader>lr", function()
	vim.lsp.buf.rename()
end, { desc = "Rename symbol" })
map(modes.normal, "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document symbols" })
map(modes.normal, "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", { desc = "Workspace symbols" })
map(modes.normal, "<leader>le", "<cmd>Telescope quickfix<cr>", { desc = "Quickfix list" })

-- Code Formatting
map(modes.normal, "<leader>mp", function()
	require("conform").format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 500,
	})
end, { desc = "Format file" })
map(modes.visual, "<leader>mp", function()
	require("conform").format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 500,
	})
end, { desc = "Format range" })

-- Search operations
map(modes.normal, "<leader>sb", "<cmd>Telescope git_branches<cr>", { desc = "Git branches" })
map(modes.normal, "<leader>sc", "<cmd>Telescope colorscheme<cr>", { desc = "Colorscheme" })
map(modes.normal, "<leader>sf", function()
	require("telescope.builtin").find_files({ hidden = true })
end, { desc = "Find files" })
map(modes.normal, "<leader>sh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
map(modes.normal, "<leader>sH", "<cmd>Telescope highlights<cr>", { desc = "Highlight groups" })
map(modes.normal, "<leader>sM", "<cmd>Telescope man_pages<cr>", { desc = "Man pages" })
map(modes.normal, "<leader>sr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })
map(modes.normal, "<leader>sR", "<cmd>Telescope registers<cr>", { desc = "Registers" })
map(modes.normal, "<leader>stt", "<cmd>Telescope live_grep<cr>", { desc = "Search text" })
map(modes.normal, "<leader>sto", "<cmd>TodoTelescope<cr>", { desc = "Search TODOs" })
map(modes.normal, "<leader>sk", "<cmd>Telescope keymaps<cr>", { desc = "Keymaps" })
map(modes.normal, "<leader>sC", "<cmd>Telescope commands<cr>", { desc = "Commands" })
map(modes.normal, "<leader>sl", "<cmd>Telescope resume<cr>", { desc = "Resume search" })
map(modes.normal, "<leader>sp", function()
	require("telescope.builtin").colorscheme({ enable_preview = true })
end, { desc = "Preview colorschemes" })
map(modes.normal, "<leader>su", "<cmd>Telescope undo<cr>", { desc = "Undo tree" })

-- Window management
map(modes.normal, "<leader>wv", "<C-w>v", { desc = "Split window vertically" })
map(modes.normal, "<leader>wh", "<C-w>s", { desc = "Split window horizontally" })
map(modes.normal, "<leader>we", "<C-w>=", { desc = "Equal window size" })
map(modes.normal, "<leader>wx", "<cmd>close<CR>", { desc = "Close window" })

-- Treesitter
map(modes.normal, "<leader>Ti", ":TSConfigInfo<cr>", { desc = "Treesitter info" })

-- Session management with persistence.nvim
map(modes.normal, "<leader>qs", function()
	require("persistence").load()
end, { desc = "Load session for current directory" })
map(modes.normal, "<leader>qS", function()
	require("persistence").select()
end, { desc = "Select session to load" })
map(modes.normal, "<leader>ql", function()
	require("persistence").load({ last = true })
end, { desc = "Load last session" })
map(modes.normal, "<leader>qd", function()
	require("persistence").stop()
end, { desc = "Don't save session on exit" })
