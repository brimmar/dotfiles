local ls = require("luasnip")
local s = ls.s -- snippet
local i = ls.i -- insert node
local t = ls.t -- text node

local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node

local fmt = require("luasnip.extras.fmt")
local rep = require("luasnip.extras").rep

local snippets, autosnippets = {}, {}

local group = vim.api.nvim_create_augroup("Blade Snippets", { clear = true })
local file_pattern = "*.blade.php"

local function cs(trigger, nodes, opts)
	local snippet = s(trigger, nodes)
	local target_table = snippets

	local pattern = file_pattern
	local keymaps = {}

	if opts ~= nil then
		-- check for custom pattern
		if opts.pattern then
			pattern = opts.pattern
		end

		-- if opts is a string
		if type(opts) == "string" then
			if opts == "auto" then
				target_table = autosnippets
			else
				table.insert(keymaps, { "i", opts })
			end
		end

		-- if opts is a table
		if opts ~= nil and type(opts) == "table" then
			for _, keymap in ipairs(opts) do
				if type(keymap) == "string" then
					table.insert(keymaps, { "i", keymap })
				else
					table.insert(keymaps, keymap)
				end
			end
		end

		-- set autocmd for each keymap
		if opts ~= "auto" then
			for _, keymap in ipairs(t) do
				vim.api.nvim_create_autocmd("BufEnter", {
					pattern = pattern,
					group = group,
					callback = function()
						vim.keymap.set(keymap[1], keymap[2], function()
							ls.snip_expand(snippet)
						end, { noremap = true, silent = true, buffer = true })
					end,
				})
			end
		end
	end

	table.insert(target_table, snippet) -- insert snippet into appropriate table
end

-- Start Refactoring --
-- Blade Snippets

-- Blade if statement
cs(
	"bif",
	fmt(
		[[
@if ({})
    {}
@endif
]],
		{
			i(1, "condition"),
			i(0),
		}
	)
)

-- Blade foreach loop
cs(
	"bforeach",
	fmt(
		[[
@foreach ({} as {})
    {}
@endforeach
]],
		{
			i(1, "$array"),
			c(2, {
				fmt("${}", { i(1, "item") }),
				fmt("${} => ${}", { i(1, "key"), i(2, "value") }),
			}),
			i(0),
		}
	)
)

-- Blade component
cs(
	"bcomp",
	fmt(
		[[
<x-{} {}>{}</x-{}>
]],
		{
			i(1, "component-name"),
			i(2, ':prop="$value"'),
			i(3),
			f(function(args)
				return args[1][1]
			end, { 1 }),
		}
	)
)

-- Blade include
cs(
	"binclude",
	fmt(
		[[
@include('{}')
]],
		{
			i(1, "view.name"),
		}
	)
)

-- Blade extends and section
cs(
	"bextends",
	fmt(
		[[
@extends('{}')

@section('{}')
    {}
@endsection
]],
		{
			i(1, "layouts.app"),
			i(2, "content"),
			i(0),
		}
	)
)

-- Blade authentication directives
cs(
	"bauth",
	fmt(
		[[
@auth
    {}
@else
    {}
@endauth
]],
		{
			i(1, "// The user is authenticated"),
			i(2, "// The user is not authenticated"),
		}
	)
)

-- Blade form elements
cs(
	"bform",
	fmt(
		[[
<form method="{}" action="{{ {} }}">
    @csrf
    {}
    <button type="submit">{}</button>
</form>
]],
		{
			c(1, { t("POST"), t("GET"), t("PUT"), t("DELETE") }),
			i(2, "route('route.name')"),
			i(3),
			i(4, "Submit"),
		}
	)
)
-- End Refactoring --

return snippets, autosnippets
