return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	opts = {
		filetypes = {
			-- cs = true,
			-- cpp = true,
			-- tex = true,
			-- lua = true,
			["*"] = false, -- disable for all other filetypes and ignore default `filetypes`
		},
		suggestion = {
			enabled = true,
			auto_trigger = true,
			hide_during_completion = true,
			debounce = 75,
			trigger_on_accept = true,
			keymap = {
				accept = "<M-j>",
				accept_line = "<M-l>",
				accept_word = false,
				next = "<M-]>",
				prev = "<M-[>",
				dismiss = "<M-d>",
			},

		},

	},
	-- config = function()
	-- 	require("copilot").setup {
	-- 	}
	-- end,
}
