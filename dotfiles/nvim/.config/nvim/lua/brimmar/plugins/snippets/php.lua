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

local group = vim.api.nvim_create_augroup("PHP/Laravel Snippets", { clear = true })
local file_pattern = "*.php"

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

-- Function to read .env file
local function read_env_file()
	local env_vars = {}
	local env_file = io.open(".env", "r")
	if env_file then
		for line in env_file:lines() do
			local key, value = line:match("^(%w+)=(.+)$")
			if key and value then
				env_vars[key] = value
			end
		end
		env_file:close()
	end
	return env_vars
end

-- Function to read Laravel config files
local function read_config_files()
	local config_values = {}
	local config_dir = "config"
	local lfs = require("lfs")

	for file in lfs.dir(config_dir) do
		if file:match("%.php$") then
			local config_file = io.open(config_dir .. "/" .. file, "r")
			if config_file then
				local content = config_file:read("*all")
				for key, value in content:gmatch("'([%w_%.]+)'%s*=>%s*([^,\n]+)") do
					config_values[key] = value
				end
				config_file:close()
			end
		end
	end
	return config_values
end

-- Cache for env vars and config values
local laravel_cache = {
	env_vars = {},
	config_values = {},
}

-- Function to refresh the cache
local function refresh_laravel_cache()
	laravel_cache.env_vars = read_env_file()
	laravel_cache.config_values = read_config_files()
end

-- Set up autocmd to refresh cache when entering a PHP file
vim.api.nvim_create_autocmd("FileType", {
	pattern = "php",
	callback = function()
		if vim.fn.filereadable(".env") == 1 then
			refresh_laravel_cache()
		end
	end,
})

-- Helper function to create choice node from cache
local function cache_choices(cache_key, default)
	return function()
		local choices = {}
		for key, _ in pairs(laravel_cache[cache_key]) do
			table.insert(choices, t(key))
		end
		table.insert(choices, i(1, default))
		return choices
	end
end

-- Start Refactoring --
-- PHP class definition
cs(
	"class",
	fmt(
		[[
<?php

class {} {}
{{
    {}
}}
]],
		{
			i(1, "ClassName"),
			c(2, {
				t(""),
				fmt("extends {}", { i(1, "ParentClass") }),
				fmt("implements {}", { i(1, "InterfaceName") }),
			}),
			i(0),
		}
	)
)

-- PHP function definition
cs(
	"fn",
	fmt(
		[[
function {}({})
{{
    {}
}}
]],
		{
			i(1, "functionName"),
			i(2),
			i(0),
		}
	)
)

-- PHP interface definition
cs(
	"interface",
	fmt(
		[[
<?php

interface {}
{{
    {}
}}
]],
		{
			i(1, "InterfaceName"),
			i(0),
		}
	)
)

-- PHP trait definition
cs(
	"trait",
	fmt(
		[[
<?php

trait {}
{{
    {}
}}
]],
		{
			i(1, "TraitName"),
			i(0),
		}
	)
)

-- PHP try-catch block
cs(
	"try",
	fmt(
		[[
try {{
    {}
}} catch ({} $e) {{
    {}
}}
]],
		{
			i(1),
			i(2, "Exception"),
			i(3, "// Handle exception"),
		}
	)
)

-- PHP foreach loop
cs(
	"foreach",
	fmt(
		[[
foreach ({} as {}) {{
    {}
}}
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
-- Snippet for env function
s(
	"lenv",
	fmt("env('{}'{});", {
		d(1, function()
			return c(1, cache_choices("env_vars", "ENV_VAR"))
		end),
		c(2, {
			t(""),
			fmt(", {}", { i(1, "'default_value'") }),
		}),
	})
)

-- Snippet for config function
s(
	"lconfig",
	fmt("config('{}'{});", {
		d(1, function()
			return c(1, cache_choices("config_values", "config.key"))
		end),
		c(2, {
			t(""),
			fmt(", {}", { i(1, "'default_value'") }),
		}),
	})
)

-- Enhanced Laravel Route definition
s(
	"lroute",
	fmt(
		[[
Route::{}('{}', [{}::class, '{}'])
    {}{}{}{}{}{}
    ->name('{}');
]],
		{
			c(1, { t("get"), t("post"), t("put"), t("patch"), t("delete"), t("resource"), t("apiResource") }),
			i(2, "path"),
			i(3, "Controller"),
			i(4, "method"),
			c(5, {
				t(""),
				fmt("->middleware({})", { i(1, "'auth'") }),
			}),
			c(6, {
				t(""),
				fmt("\n    ->where({})", { i(1, "'id' => '[0-9]+'") }),
			}),
			c(7, {
				t(""),
				fmt("\n    ->domain({})", { i(1, "'subdomain.example.com'") }),
			}),
			c(8, {
				t(""),
				fmt("\n    ->prefix({})", { i(1, "'admin'") }),
			}),
			c(9, {
				t(""),
				fmt("\n    ->namespace({})", { i(1, "'App\\Http\\Controllers\\Admin'") }),
			}),
			c(10, {
				t(""),
				fmt("\n    ->as({})", { i(1, "'admin.'") }),
			}),
			i(11, "route.name"),
		}
	)
)

-- Enhanced Laravel Eloquent relationship
s(
	"lrel",
	fmt(
		[[
public function {}()
{{
    return $this->{}({}{}{});
}}
]],
		{
			i(1, "relationName"),
			c(2, {
				t("hasOne"),
				t("hasMany"),
				t("belongsTo"),
				t("belongsToMany"),
				t("hasOneThrough"),
				t("hasManyThrough"),
				t("morphOne"),
				t("morphMany"),
				t("morphTo"),
				t("morphToMany"),
			}),
			i(3, "RelatedModel::class"),
			c(4, {
				t(""),
				fmt(", '{}'{}", {
					i(1, "foreign_key"),
					c(2, {
						t(""),
						fmt(", '{}'", { i(1, "local_key") }),
					}),
				}),
			}),
			c(5, {
				t(""),
				fmt("\n        ->withPivot({})", { i(1, "'column1', 'column2'") }),
				fmt("\n        ->withTimestamps()", {}),
				fmt("\n        ->withTrashed()", {}),
				fmt("\n        ->as('{}')", { i(1, "alias") }),
				fmt("\n        ->orderBy('{}')", { i(1, "column") }),
			}),
		}
	)
)
cs(
	"ftextinput",
	fmt(
		[[
Forms\Components\TextInput::make('{}')
    ->label('{}')
    ->placeholder('{}'){}{}{}
]],
		{
			i(1, "field_name"),
			i(2, "Label"),
			i(3, "Enter text..."),
			c(4, {
				t(""),
				t("\n    ->required()"),
				t("\n    ->nullable()"),
			}),
			c(5, {
				t(""),
				fmt("\n    ->maxLength({})", { i(1, "255") }),
			}),
			c(6, {
				t(""),
				fmt("\n    ->helperText('{}')", { i(1, "Helper text here") }),
			}),
		}
	)
)

-- Select
cs(
	"fselect",
	fmt(
		[[
Forms\Components\Select::make('{}')
    ->label('{}')
    ->options([
        {}
    ]){}{}{}
]],
		{
			i(1, "field_name"),
			i(2, "Label"),
			i(3, "// 'value' => 'Label',"),
			c(4, {
				t(""),
				t("\n    ->required()"),
				t("\n    ->nullable()"),
			}),
			c(5, {
				t(""),
				t("\n    ->searchable()"),
				t("\n    ->multiple()"),
			}),
			c(6, {
				t(""),
				fmt("\n    ->placeholder('{}')", { i(1, "Select an option") }),
			}),
		}
	)
)

-- Checkbox
cs(
	"fcheckbox",
	fmt(
		[[
Forms\Components\Checkbox::make('{}')
    ->label('{}'){}{}
]],
		{
			i(1, "field_name"),
			i(2, "Label"),
			c(3, {
				t(""),
				t("\n    ->required()"),
			}),
			c(4, {
				t(""),
				fmt("\n    ->helperText('{}')", { i(1, "Helper text here") }),
			}),
		}
	)
)

-- Date Picker
cs(
	"fdatepicker",
	fmt(
		[[
Forms\Components\DatePicker::make('{}')
    ->label('{}'){}{}{}
]],
		{
			i(1, "field_name"),
			i(2, "Label"),
			c(3, {
				t(""),
				t("\n    ->required()"),
				t("\n    ->nullable()"),
			}),
			c(4, {
				t(""),
				fmt("\n    ->minDate({})", { i(1, "now()") }),
				fmt("\n    ->maxDate({})", { i(1, "now()->addYear()") }),
			}),
			c(5, {
				t(""),
				t("\n    ->displayFormat('d/m/Y')"),
				t("\n    ->format('Y-m-d')"),
			}),
		}
	)
)

-- Rich Editor (Fixed)
cs(
	"fricheditor",
	fmt(
		[[
Forms\Components\RichEditor::make('{}')
    ->label('{}'){}{}{}
]],
		{
			i(1, "field_name"),
			i(2, "Label"),
			c(3, {
				t(""),
				t("\n    ->required()"),
				t("\n    ->nullable()"),
			}),
			c(4, {
				t(""),
				fmt("\n    ->maxLength({})", { i(1, "65535") }),
			}),
			c(5, {
				t(""),
				fmt("\n    ->toolbarButtons({})", {
					t("['bold', 'italic', 'link', 'bulletList', 'orderedList', 'redo', 'undo']"),
				}),
			}),
		}
	)
)

-- File Upload
cs(
	"ffileupload",
	fmt(
		[[
Forms\Components\FileUpload::make('{}')
    ->label('{}'){}{}{}{}
]],
		{
			i(1, "field_name"),
			i(2, "Label"),
			c(3, {
				t(""),
				t("\n    ->required()"),
				t("\n    ->nullable()"),
			}),
			c(4, {
				t(""),
				t("\n    ->image()"),
				fmt("\n    ->acceptedFileTypes(['{}'])", { i(1, "application/pdf") }),
			}),
			c(5, {
				t(""),
				fmt("\n    ->maxSize({})", { i(1, "1024") }),
			}),
			c(6, {
				t(""),
				t("\n    ->directory('uploads')"),
				fmt("\n    ->visibility('{}')", { i(1, "private") }),
			}),
		}
	)
)

-- Toggle
cs(
	"ftoggle",
	fmt(
		[[
Forms\Components\Toggle::make('{}')
    ->label('{}'){}{}
]],
		{
			i(1, "field_name"),
			i(2, "Label"),
			c(3, {
				t(""),
				t("\n    ->required()"),
			}),
			c(4, {
				t(""),
				fmt("\n    ->onColor('{}')", { i(1, "success") }),
				fmt("\n    ->offColor('{}')", { i(1, "danger") }),
			}),
		}
	)
)

-- Repeater
cs(
	"frepeater",
	fmt(
		[[
Forms\Components\Repeater::make('{}')
    ->label('{}')
    ->schema([
        {}
    ]){}{}
]],
		{
			i(1, "field_name"),
			i(2, "Label"),
			i(3, "// Add form components here"),
			c(4, {
				t(""),
				fmt("\n    ->defaultItems({})", { i(1, "1") }),
				fmt("\n    ->minItems({})", { i(1, "1") }),
				fmt("\n    ->maxItems({})", { i(1, "5") }),
			}),
			c(5, {
				t(""),
				fmt("\n    ->createItemButtonLabel('{}')", { i(1, "Add Item") }),
			}),
		}
	)
)

-- Table Column (Text)
cs(
	"ftcoltext",
	fmt(
		[[
Tables\Columns\TextColumn::make('{}')
    ->label('{}'){}{}{}
]],
		{
			i(1, "column_name"),
			i(2, "Label"),
			c(3, {
				t(""),
				t("\n    ->sortable()"),
				t("\n    ->searchable()"),
			}),
			c(4, {
				t(""),
				fmt("\n    ->formatStateUsing(fn (string $state): string => {})", { i(1, "// Format here") }),
			}),
			c(5, {
				t(""),
				fmt("\n    ->description({})", { i(1, "fn ($record) => $record->description") }),
			}),
		}
	)
)

-- Table Column (Boolean)
cs(
	"ftcolbool",
	fmt(
		[[
Tables\Columns\BooleanColumn::make('{}')
    ->label('{}'){}{}
]],
		{
			i(1, "column_name"),
			i(2, "Label"),
			c(3, {
				t(""),
				t("\n    ->sortable()"),
			}),
			c(4, {
				t(""),
				fmt("\n    ->trueIcon('{}')", { i(1, "heroicon-o-check-circle") }),
				fmt("\n    ->falseIcon('{}')", { i(1, "heroicon-o-x-circle") }),
			}),
		}
	)
)
-- End Refactoring --
return snippets, autosnippets
