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

local group = vim.api.nvim_create_augroup("Javascript Snippets", { clear = true })
local file_pattern = "*.js"

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
			for _, keymap in ipairs(keymaps) do
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
-- Comprehensive fetch snippet
cs(
	"fetch",
	fmt(
		[[
fetch({}{})
  .then(response => {{
    if (!response.ok) {{
      throw new Error(`HTTP error! status: ${{response.status}}`);
    }}
    return response.{};
  }})
  .then(data => {{
    console.log(data);
    {}
  }})
  .catch(error => {{
    console.error('There was a problem with the fetch operation:', error);
    {}
  }}){}
]],
		{
			i(1, "'https://api.example.com/data'"),
			c(2, {
				t(""),
				fmt(
					[[, {{
    method: '{}',
    headers: {{
      'Content-Type': 'application/json',
    }},
    body: JSON.stringify({{
      {}
    }}),
  }}]],
					{
						c(1, {
							t("POST"),
							t("PUT"),
							t("DELETE"),
							t("PATCH"),
						}),
						i(2, "key: 'value'"),
					}
				),
			}),
			c(3, {
				t("json()"),
				t("text()"),
				t("blob()"),
				t("formData()"),
				t("arrayBuffer()"),
			}),
			i(4, "// Handle the data"),
			i(5, "// Handle the error"),
			c(6, {
				t(""),
				fmt(
					[[
  .finally(() => {{
    {}
  }})]],
					{
						i(1, "// This will always execute"),
					}
				),
			}),
		}
	)
)

-- addEventListener snippet
cs(
	"addevent",
	fmt(
		[[
{}.addEventListener('{}', {}{}{}
);
]],
		{
			c(1, {
				t("document"),
				t("window"),
				i(1, "element"),
			}),
			c(2, {
				t("click"),
				t("submit"),
				t("keydown"),
				t("load"),
				t("DOMContentLoaded"),
				i(1, "event"),
			}),
			c(3, {
				fmt("(event) => {{\n  {}\n}}", {
					i(1, "// Event handler code here"),
				}),
				fmt("function(event) {{\n  {}\n}}", {
					i(1, "// Event handler code here"),
				}),
				i(1, "handlerFunction"),
			}),
			c(4, {
				t(""),
				fmt(
					[[, {{
  once: {},
  capture: {},
  passive: {}
}}]],
					{
						c(1, { t("true"), t("false") }),
						c(2, { t("true"), t("false") }),
						c(3, { t("true"), t("false") }),
					}
				),
			}),
			c(5, {
				t(""),
				t(", true"), -- For older syntax with useCapture parameter
			}),
		}
	)
)

-- removeEventListener snippet
cs(
	"removeevent",
	fmt(
		[[
{}.removeEventListener('{}', {}{});
]],
		{
			c(1, {
				t("document"),
				t("window"),
				i(1, "element"),
			}),
			c(2, {
				t("click"),
				t("submit"),
				t("keydown"),
				t("load"),
				t("DOMContentLoaded"),
				i(1, "event"),
			}),
			i(3, "handlerFunction"),
			c(4, {
				t(""),
				t(", true"), -- For older syntax with useCapture parameter
			}),
		}
	)
)

-- Promise snippet
cs(
	"promise",
	fmt(
		[[
new Promise((resolve, reject) => {{
  {}
}})
  .then(result => {{
    {}
  }})
  .catch(error => {{
    {}
  }}){}
]],
		{
			i(1, "// Asynchronous operation here"),
			i(2, "// Handle successful result"),
			i(3, "// Handle error"),
			c(4, {
				t(""),
				fmt(
					[[
  .finally(() => {{
    {}
  }})]],
					{
						i(1, "// This will always execute"),
					}
				),
			}),
		}
	)
)

-- Async function snippet
cs(
	"asyncfunc",
	fmt(
		[[
async function {}({}) {{
  try {{
    {}
  }} catch (error) {{
    {}
  }}
}}
]],
		{
			i(1, "functionName"),
			i(2, ""),
			i(3, "// Asynchronous operations here"),
			i(4, "console.error('An error occurred:', error)"),
		}
	)
)

-- ES6 Module import snippet
cs(
	"import",
	fmt(
		[[
import {} from '{}';
]],
		{
			c(1, {
				i(1, "{ module }"),
				fmt("{{ {} }}", {
					i(1, "namedExport"),
				}),
				fmt("* as {}", {
					i(1, "namespace"),
				}),
				t("defaultExport"),
			}),
			i(2, "./module"),
		}
	)
)

-- ES6 Module export snippet
cs(
	"export",
	c(1, {
		fmt([[export default {}]], {
			i(1, "expression"),
		}),
		fmt([[export const {} = {}]], {
			i(1, "name"),
			i(2, "value"),
		}),
		fmt(
			[[export function {}({}) {{
  {}
}}]],
			{
				i(1, "functionName"),
				i(2, ""),
				i(3, "// Function body"),
			}
		),
		fmt(
			[[export class {} {{
  {}
}}]],
			{
				i(1, "ClassName"),
				i(2, "// Class body"),
			}
		),
	})
)
-- End Refactoring --

return snippets, autosnippets
