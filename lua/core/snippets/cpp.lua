local ls = require("luasnip")
local ts_utils = require("nvim-treesitter.ts_utils")
local lsa = ls.add_snippets
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key
local ts_post = require("luasnip.extras.treesitter_postfix").treesitter_postfix
local mconds = require("luasnip.extras.conditions").make_condition



lsa("cpp", {
	s("#debug_print",
		t({ "#ifndef DEBUG", "#define print(...)", "#endif", "#ifdef DEBUG",
			'#define print(...) printf(__VA_ARGS__); std::cout << endl;', "#endif" })),
	s("#debug_print_stl",
		t({ "#ifndef DEBUG", "#define printSTL(v)", "#endif", "#ifdef DEBUG",
			'#define printSTL(v) for(auto && vv: v) std::cout << vv << " "; std::cout << endl;', "#endif" })),
	s(
		"fori",
		fmt(
			[[
		for(int i = {1}; i < {2}; ++i){{
			{3}
		}}
		]],
			{
				i(1, "0"),
				i(2, "n"),
				i(3)
			}
		)
	),
}, {
	key = "cpp"
}
)
