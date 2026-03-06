local ls = require("luasnip")
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

lsa("cs", {
	s(
		"vmethodf",
		fmta(
			[[
		public void <1> (float <2>)
		{

		}
		]],
			{
				i(1, "MetName"),
				i(2, "varName"),
			}
		)
	),
	s(
		"fmethod",
		fmta(
			[[
		<2> float <1> ()
		{
			return 0;
		}
		]],
			{
				i(1, "MetName"),
				i(2, "public"),
			}
		)
	),
	s(
		"vmethod",
		fmta(
			[[
		<2> void <1> ()
		{

		}
		]],
			{
				i(1, "MetName"),
				i(2, "public"),
			}
		)
	),
	s(
		"signal",
		fmta("[Signal]\npublic delegate void S<1>EventHandler(<2>);", {
			i(1, "SignalName"),
			i(2),
		})
	),
	s(
		"e-props",
		fmta("[Export]\npublic <1> <2> { get; set; }<3>", {
			i(1, "type"),
			i(2, "Name"),
			i(3),
		})
	),
	s("getn", {
		t([[GetNode<]]),
		i(1, "type"),
		t([[>("]]),
		dl(2, l._1, 1),
		t([[");]]),
	}),
	s("=get", {
		i(1, "type"),
		t(" "),
		i(2, "name"),
		t(" = "),
		t([[GetNode<]]),
		dl(4, l._1, 1),
		t([[>("]]),
		dl(3, l._1, 2),
		t([[");]]),
	}),
	s(
		"print",
		fmta(
			[[
			GD.Print("<1>")
		]],
			{
				i(1),
			}
		)
	),
	s(
		"ready",
		fmta(
			[[
			public override void _Ready()
			{
				<1>
			}
		]],
			{
				i(1),
			}
		)
	),
	s(
		"lambda",
		fmt("({1}) => {{ {2} }};", {
			i(1),
			i(2),
		})
	),
	s(
		"load",
		fmt('GD.Load<{1}>("{2}")', {
			i(1, "type"),
			i(2, "path"),
		})
	),
	s(
		"addChildDeffered",
		fmt("CallDeferred(MethodName.AddChild,{1});", {
			i(1, "node"),
		})
	),
	s(
		"summary",
		fmt("///<summary>\n///{1}\n///</summary>", {
			i(1, "desc"),
		})
	),
	s(
		"param",
		fmt('<param name = "{1}">{2}</param>', {
			i(1, "var"),
			i(2, "desc"),
		})
	),

	s(
		"returns",
		fmt('<returns>{1}</returns>', {
			i(1, "desc"),
		})
	),

	postfix(".valid", {
		f(function(_, parent)
			if parent.snippet.env.POSTFIX_MATCH ~= nil then
				return "IsInstanceValid(" .. parent.snippet.env.POSTFIX_MATCH .. ")"
			end
			return ""
		end),
	}),
}, {
	key = "cs",
})
