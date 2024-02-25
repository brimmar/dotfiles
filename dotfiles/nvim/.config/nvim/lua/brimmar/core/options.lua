local opt = vim.opt
local get_cache_dir = function()
	local cache_dir = os.getenv("NEOVIM_CACHE_DIR")
	if not cache_dir then
		return vim.call("stdpath", "cache")
	end
	return cache_dir
end
local join_paths = function(...)
	local path_sep = vim.loop.os_uname().version:match("Windows") and "\\" or "/"
	local result = table.concat({ ... }, path_sep)
	return result
end
local is_directory = function(path)
	local stat = vim.loop.fs_stat(path)
	return stat and stat.type == "directory" or false
end
local undodir = join_paths(get_cache_dir(), "undo")

if not is_directory(undodir) then
	vim.fn.mkdir(undodir, "p")
end

-- line numbers
opt.relativenumber = false -- show relative line numbers
opt.number = true -- shows absolute line number

-- tabs and indentation
opt.tabstop = 4 -- spaces for tabs
opt.shiftwidth = 4 -- spaces for indent width
opt.autoindent = true -- copy indent from current line when starting new one

-- line wrapping
opt.wrap = false -- disable line wrapping

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- appearance

-- turn on termguicolors for true colors terminal
opt.termguicolors = true

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

opt.updatetime = 100
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.laststatus = 3
opt.conceallevel = 0
opt.showmode = false
opt.undodir = undodir
opt.undofile = true
opt.clipboard = "unnamedplus"

vim.filetype.add({
	pattern = {
		["[jt]sconfig.*.json"] = "jsonc",
	},
})
