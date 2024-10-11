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
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
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
