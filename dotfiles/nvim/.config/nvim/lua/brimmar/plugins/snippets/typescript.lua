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

local group = vim.api.nvim_create_augroup("Typescript Snippets", { clear = true })
local file_pattern = "*.ts"

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
-- Interface declaration
cs(
	"tsinterface",
	fmt(
		[[
interface {} {{
  {}: {};
  {}: {};
}}
]],
		{
			i(1, "InterfaceName"),
			i(2, "propertyName"),
			i(3, "PropertyType"),
			i(4, "optionalProperty"),
			c(5, {
				fmt("{}?", { i(1, "PropertyType") }),
				fmt("{}[] | null", { i(1, "PropertyType") }),
				fmt("{}[]", { i(1, "PropertyType") }),
			}),
		}
	)
)

-- Type alias
cs(
	"tstype",
	fmt(
		[[
type {} = {};
]],
		{
			i(1, "TypeName"),
			c(2, {
				i(1, "BaseType"),
				fmt("{{ {} }}", { i(1, "propertyName: PropertyType") }),
				fmt("{}[]", { i(1, "BaseType") }),
				fmt("{} | {}", { i(1, "Type1"), i(2, "Type2") }),
				fmt("Partial<{}>", { i(1, "BaseType") }),
				fmt("Omit<{}, {}>", { i(1, "BaseType"), i(2, "'propertyToOmit'") }),
			}),
		}
	)
)

-- Generic type
cs(
	"tsgeneric",
	fmt(
		[[
{}<{}>{}
]],
		{
			c(1, {
				t("type"),
				t("interface"),
				t("class"),
				t("function"),
			}),
			i(2, "T"),
			c(3, {
				fmt([[ = {} ]], { i(1, "BaseType") }),
				fmt(
					[[ {{
  {}: {};
}}]],
					{ i(1, "property"), i(2, "T") }
				),
				fmt([[ extends {}]], { i(1, "BaseType") }),
				fmt([[<{}>({}: {}) => {}]], { rep(2), i(1, "param"), rep(2), i(2, "ReturnType") }),
			}),
		}
	)
)

-- Union type
cs(
	"tsunion",
	fmt(
		[[
type {} = {} | {} | {};
]],
		{
			i(1, "UnionType"),
			i(2, "Type1"),
			i(3, "Type2"),
			i(4, "Type3"),
		}
	)
)

-- Intersection type
cs(
	"tsintersection",
	fmt(
		[[
type {} = {} & {} & {};
]],
		{
			i(1, "IntersectionType"),
			i(2, "Type1"),
			i(3, "Type2"),
			i(4, "Type3"),
		}
	)
)

-- Utility types
cs(
	"tsutility",
	fmt(
		[[
type {} = {}
]],
		{
			i(1, "NewType"),
			c(2, {
				fmt("Partial<{}>", { i(1, "Type") }),
				fmt("Required<{}>", { i(1, "Type") }),
				fmt("Readonly<{}>", { i(1, "Type") }),
				fmt("Record<{}, {}>", { i(1, "KeyType"), i(2, "ValueType") }),
				fmt("Pick<{}, {}>", { i(1, "Type"), i(2, "'prop1' | 'prop2'") }),
				fmt("Omit<{}, {}>", { i(1, "Type"), i(2, "'prop1' | 'prop2'") }),
				fmt("Exclude<{}, {}>", { i(1, "UnionType"), i(2, "ExcludedMembers") }),
				fmt("Extract<{}, {}>", { i(1, "Type"), i(2, "Union") }),
				fmt("NonNullable<{}>", { i(1, "Type") }),
				fmt("ReturnType<typeof {}>", { i(1, "function") }),
				fmt("InstanceType<typeof {}>", { i(1, "Class") }),
			}),
		}
	)
)

-- Type assertion
cs(
	"tsassert",
	fmt(
		[[
const {} = {} as {};
]],
		{
			i(1, "variable"),
			i(2, "value"),
			i(3, "Type"),
		}
	)
)

-- Enum declaration
cs(
	"tsenum",
	fmt(
		[[
enum {} {{
  {} = {},
  {} = {},
  {} = {},
}}
]],
		{
			i(1, "EnumName"),
			i(2, "FirstValue"),
			i(3, "0"),
			i(4, "SecondValue"),
			i(5, "1"),
			i(6, "ThirdValue"),
			i(7, "2"),
		}
	)
)

cs(
	"tsclass",
	fmt(
		[[
class {} implements {} {{
  constructor({}) {{
    {}
  }}

  {}({}){}
}}
]],
		{
			i(1, "ClassName"),
			i(2, "InterfaceName"),
			i(3, "private param: Type"),
			i(4, "this.param = param;"),
			i(5, "methodName"),
			i(6, "param: Type"),
			c(7, {
				fmt(": {} {{\n    {}\n  }}", {
					i(1, "ReturnType"),
					i(2, "// Method implementation"),
				}),
				fmt(" {{\n    {}\n  }}", {
					i(1, "// Method implementation"),
				}),
			}),
		}
	)
)

-- Mapped type
cs(
	"tsmapped",
	fmt(
		[[
type {} = {{
  [K in keyof {}]: {}
}}
]],
		{
			i(1, "MappedType"),
			i(2, "SourceType"),
			c(3, {
				rep(2),
				fmt("{}[K]", { rep(2) }),
				fmt("{}[K] | null", { rep(2) }),
				i(1, "NewType"),
			}),
		}
	)
)

-- Conditional type
cs(
	"tsconditional",
	fmt(
		[[
type {} = {} extends {} ? {} : {};
]],
		{
			i(1, "ConditionalType"),
			i(2, "Type"),
			i(3, "Condition"),
			i(4, "TrueType"),
			i(5, "FalseType"),
		}
	)
)

-- Type guard
cs(
	"tsguard",
	fmt(
		[[
function is{}(obj: any): obj is {} {{
  return {} in obj && typeof obj.{} === '{}';
}}
]],
		{
			i(1, "TypeName"),
			rep(1),
			i(2, "propertyName"),
			rep(2),
			i(3, "expectedType"),
		}
	)
)
-- End Refactoring --

return snippets, autosnippets
