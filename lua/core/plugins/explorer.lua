return {
	'stevearc/oil.nvim',
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
	},
	keys = {
		{
			"<leader>ee",
			mode = { "n", "v" },
			"<cmd>Oil<cr>",
			desc = "Open default file explorer",
		},
		{
			"<Leader>ef",
			mode = { "n" },
			"<cmd>lua require('oil').open_float()<CR>",
			desc = "Open default file explorer with float window",
		},

	},
	-- Optional dependencies
	dependencies = { "echasnovski/mini.icons", "nvim-tree/nvim-web-devicons" },
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
}
