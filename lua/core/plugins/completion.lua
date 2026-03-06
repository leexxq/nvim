-- local kind_icons = {
-- 	Text = "  ",
-- 	Method = "  ",
-- 	Function = "  ",
-- 	Constructor = "  ",
-- 	Field = "  ",
-- 	Variable = "  ",
-- 	Class = "  ",
-- 	Interface = "  ",
-- 	Module = "  ",
-- 	Property = "  ",
-- 	Unit = "  ",
-- 	Value = "  ",
-- 	Enum = "  ",
-- 	Keyword = "  ",
-- 	Snippet = "  ",
-- 	Color = "  ",
-- 	File = "  ",
-- 	Reference = "  ",
-- 	Folder = "  ",
-- 	EnumMember = "  ",
-- 	Constant = "  ",
-- 	Struct = "  ",
-- 	Event = "  ",
-- 	Operator = "  ",
-- 	TypeParameter = "  ",
-- }

return {
	{
		'saghen/blink.cmp',
		-- optional: provides snippets for the snippet source
		dependencies = { 'rafamadriz/friendly-snippets' },

		-- use a release tag to download pre-built binaries
		version = '1.*',
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		-- Exceptions: vim.bo.filetype == 'dap-repl'
		opts = {
			enabled = function() return not vim.tbl_contains({ "dap-repl" }, vim.bo.filetype) end,
			keymap = {
				-- set to 'none' to disable the 'default' preset
				preset = 'none',

				['<Up>'] = { 'select_prev', 'fallback' },

				['<Down>'] = { 'select_next', 'fallback' },

				['<CR>'] = { 'accept', 'fallback' },

				['<Tab>'] = { function(cmp)
					if cmp.is_visible() then
						cmp.select_next()
						return true
					end
				end, 'fallback' },

				['<S-Tab>'] = { function(cmp)
					if cmp.is_visible() then
						cmp.select_prev()
						return true
					end
				end, 'fallback' },


				['<C-j>'] = { function(cmp)
					if cmp.snippet_active() then
						return cmp.accept()
					else
						return cmp.select_and_accept()
					end
				end,
					'snippet_forward',
					'fallback'
				},


				['<C-k>'] = { 'snippet_backward', 'fallback' },

				['<C-n>'] = { 'select_and_accept' },

				['<C-p>'] = { 'cancel' },


				['<C-d>'] = { 'show_documentation', 'scroll_documentation_down' },

				['<C-u>'] = { 'scroll_documentation_up' },

				['<C-h>'] = { 'show_documentation', 'hide_documentation' },

				-- ['<C-S>'] = { 'show_signature', 'hide_signature', 'fallback' },
				['<C-S>'] = false,
			},
			cmdline = { enabled = false },
			appearance = {
				nerd_font_variant = 'mono',
			},

			-- (Default) Only show the documentation popup when manually triggered
			completion = {
				documentation = {
					auto_show = false,
					window = {
						scrollbar = false,
						border = "rounded"
					}
				},
				menu = {
					border = "rounded",
					scrollbar = false
				}
			},

			snippets = { preset = 'luasnip' },

			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						-- make lazydev completions top priority (see `:h blink.cmp`)
						score_offset = 100,
					},
				},
			},

			fuzzy = { implementation = "prefer_rust_with_warning" },

		},
		opts_extend = { "sources.default" }

	},
	{
		"L3MON4D3/LuaSnip",
		build = "make install_jsregexp",
		event = "VeryLazy",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
	},

}
