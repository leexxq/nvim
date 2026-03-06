return {
	"folke/lazydev.nvim",
	ft = "lua",  -- only load on lua files
	opts = {
		enable = true, -- enable the plugin
		library = {
			{ path = "plenary.nvim",       words = { "plenary" } },
			"lazy.nvim",
			-- 4. Load the 'vim' global (usually automatic, but good to be explicit if issues arise)
			-- This loads the Neovim runtime types
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		},
	},

}
