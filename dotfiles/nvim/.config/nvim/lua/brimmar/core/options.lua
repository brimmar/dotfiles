local opt = vim.opt

-- get the cache dir
local get_cache_dir = function()
	local cache_dir = os.getenv("NEOVIM_CACHE_DIR")
	if not cache_dir then
		return vim.call("stdpath", "cache")
	end
	return cache_dir
end

-- constructs the path by joining the strings
local join_paths = function(...)
	local path_sep = vim.loop.os_uname().version:match("Windows") and "\\" or "/"
	local result = table.concat({ ... }, path_sep)
	return result
end

-- check if the path is a directory
local is_directory = function(path)
	local stat = vim.loop.fs_stat(path)
	return stat and stat.type == "directory" or false
end
local undodir = join_paths(get_cache_dir(), "undo")

-- if it's not a directory already, create that directory to be the undofile
if not is_directory(undodir) then
	vim.fn.mkdir(undodir, "p")
end

-- line numbers
opt.number = true -- shows absolute line number

-- tabs and indentation
opt.tabstop = 4 -- spaces for tabs
opt.shiftwidth = 4 -- spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- line wrapping
opt.wrap = false -- disable line wrapping

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- appearance

-- turn on termguicolors for true colors terminal
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

-- scrolling
opt.scrolloff = 8 -- number of lines to behave like the edge so it starts scrolling top or bottom
opt.sidescrolloff = 8 -- number of lines to behave like the edge so it starts scrolling right or left

opt.laststatus = 3
opt.conceallevel = 0
opt.showmode = false

-- undo
opt.undofile = true
opt.undodir = undodir -- sets the undo cache directory so you can undo things between sessions

-- clipboard
opt.clipboard = "unnamedplus" -- use system clipboard as default register

-- additional filetypes
vim.filetype.add({
	pattern = {
		["[jt]sconfig.*.json"] = "jsonc",
		[".hyperland.conf"] = "hyprlang",
	},
})
