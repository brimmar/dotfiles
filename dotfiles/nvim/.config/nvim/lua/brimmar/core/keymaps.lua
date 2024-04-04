local mode_adapters = {
	insert_mode = "i",
	normal_mode = "n",
	term_mode = "t",
	visual_mode = "v",
	visual_block_mode = "x",
	command_mode = "c",
	operator_pending_mode = "o",
}

vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set(
	mode_adapters.normal_mode,
	"<C-h>",
	"<C-w>h",
	{ desc = "Move left one window", noremap = true, silent = true }
) -- move left one window
keymap.set(
	mode_adapters.normal_mode,
	"<C-j>",
	"<C-w>j",
	{ desc = "Move down one window", noremap = true, silent = true }
) -- move down one window
keymap.set(mode_adapters.normal_mode, "<C-k>", "<C-w>k", { desc = "Move up one window", noremap = true, silent = true }) -- move up one window
keymap.set(mode_adapters.normal_mode, "<C-l>", "<C-w>l", { desc = "Move up one window", noremap = true, silent = true }) -- move up one window
keymap.set(
	mode_adapters.normal_mode,
	"<C-Up>",
	":resize -2<CR>",
	{ desc = "Resize the current window", noremap = true, silent = true }
) -- resize the window
keymap.set(
	mode_adapters.normal_mode,
	"<C-Down>",
	":resize +2<CR>",
	{ desc = "Resize the current window", noremap = true, silent = true }
) -- resize the window
keymap.set(
	mode_adapters.normal_mode,
	"<C-Left>",
	":vertical resize -2<CR>",
	{ desc = "Resize the current window", noremap = true, silent = true }
) -- resize the window
keymap.set(
	mode_adapters.normal_mode,
	"<C-Right>",
	":vertical resize +2<CR>",
	{ desc = "Resize the current window", noremap = true, silent = true }
) -- resize the window
keymap.set(mode_adapters.visual_mode, "<", "<gv", { desc = "Indent Line to the right", noremap = true, silent = true }) -- better indenting
keymap.set(mode_adapters.visual_mode, ">", ">gv", { desc = "Indent Line to the left", noremap = true, silent = true }) -- better indenting
keymap.set(mode_adapters.visual_block_mode, "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true }) -- drag the code block up
keymap.set(mode_adapters.visual_block_mode, "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true }) -- drag the code block down
