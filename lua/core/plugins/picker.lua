return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		bigfile = { enabled = true },
		dashboard = { enabled = true },
		explorer = { enabled = true },
		indent = { enabled = true },
		input = { enabled = true },
		picker = { enabled = true },
		notifier = {
			enabled = true,
			timeout = 1000,
		},
		quickfile = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = false },
		statuscolumn = { enabled = true },
		words = { enabled = true },
	},
	keys = {
		-- common
		{ "<leader>fs", function() Snacks.picker.smart() end,                                   desc = "Smart Find Files" },
		{ "<leader>:",  function() Snacks.picker.command_history() end,                         desc = "Command History" },
		{ "<leader>es", function() Snacks.explorer() end,                                       desc = "File Explorer" },
		{ "<leader>n",  function() Snacks.picker.notifications() end,                           desc = "Notification History" },
		{ "<leader>bd", function() Snacks.bufdelete() end,                                      desc = "Delete Buffer" },
		-- find
		{ "<leader>fg", function() Snacks.picker.grep() end,                                    desc = "Grep" },
		{ "<leader>fb", function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
		{ "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
		{ "<leader>ff", function() Snacks.picker.files() end,                                   desc = "Find Files" },
		{ "<leader>ft", function() Snacks.picker.git_files() end,                               desc = "Find Git Files" },
		{ "<leader>fp", function() Snacks.picker.projects() end,                                desc = "Projects" },
		{ "<leader>fr", function() Snacks.picker.recent() end,                                  desc = "Recent" },
		{ '<leader>f"', function() Snacks.picker.registers() end,                               desc = "Registers" },
		{ "<leader>fq", function() Snacks.picker.qflist() end,                                  desc = "Quickfix List" },
		{ "<leader>fH", function() Snacks.picker.highlights() end,                              desc = "Highlights" },
		--LSP
		{ "<leader>p",  vim.lsp.buf.format,                                                     desc = "Prettify code" },
		{
			"gd",
			function()
				local params = vim.lsp.util.make_position_params(0, 'utf-8')
				vim.lsp.buf_request(0, 'textDocument/definition', params, function(_, result, _, _)
					if not result or vim.tbl_isempty(result) then
						vim.notify('No definition found', vim.log.levels.INFO)
					else
						Snacks.picker.lsp_definitions()
					end
				end)
			end,
			desc = 'LSP: Goto Definition'
		},
		{
			"gD",
			function()
				vim.diagnostic.open_float({
					border = "rounded",
				})
			end
			,
			desc = "open cursol line diagnostic"
		},
		{
			'<C-W>gd',
			function()
				local win = vim.api.nvim_get_current_win()
				local width = vim.api.nvim_win_get_width(win)
				local height = vim.api.nvim_win_get_height(win)

				-- Mimic tmux formula: 8 * width - 20 * height
				local value = 8 * width - 20 * height
				if value < 0 then
					vim.cmd 'split' -- vertical space is more: horizontal split
				else
					vim.cmd 'vsplit' -- horizontal space is more: vertical split
				end
				vim.lsp.buf.definition()
			end,
			desc = 'LSP: Goto Definition (split)'
		},
		{ "gC",  function() Snacks.picker.lsp_declarations() end,      desc = "Goto Declaration" },
		{ "gr",  function() Snacks.picker.lsp_references() end,        nowait = true,                  desc = "References" },
		{ "gI",  function() Snacks.picker.lsp_implementations() end,   desc = "Goto Implementation" },
		{ "gy",  function() Snacks.picker.lsp_type_definitions() end,  desc = "Goto T[y]pe Definition" },
		{ "gai", function() Snacks.picker.lsp_incoming_calls() end,    desc = "C[a]lls Incoming" },
		{ "gao", function() Snacks.picker.lsp_outgoing_calls() end,    desc = "C[a]lls Outgoing" },
		{ "gs",  function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols" },
		{ "gS",  function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
		{ "gR",  function() vim.lsp.buf.rename() end,                  desc = "LSP Rename" },
		{ "K", function()
			vim.lsp.buf.hover({
				border = "rounded",
			})
		end, { desc = 'LSP: Open Document' } },
		-- Terminal
		{ "<c-/>", function() Snacks.terminal() end, desc = "Toggle Terminal" },
	},
	-- init = function()
	-- end
}

-- {

-- "nvim-telescope/telescope.nvim",
-- dependencies = {
-- 	"nvim-lua/plenary.nvim",
-- },
-- keys = {
-- 	-- Telescope notify
-- 	{
-- 		"<Leader>n",
-- 		mode = { "n" },
-- 		"<cmd>Telescope notify<CR>",
-- 		desc = "open the notification page",
-- 	},
-- 	-- Telescope oldfiles
-- 	{
-- 		"<leader>fo",
-- 		mode = { "n" },
-- 		"<cmd>Telescope oldfiles<CR>",
-- 		desc = "open the old files",
-- 	},
-- 	-- Telescope filetypes
-- 	{
-- 		"<leader>ft",
-- 		mode = { "n" },
-- 		"<cmd>Telescope filetypes<CR>",
-- 		desc = "set file type",
-- 	},
-- 	-- Telescope find_files
-- 	{
-- 		"<Leader>ff",
-- 		mode = { "n" },
-- 		"<cmd>Telescope find_files<CR>",
-- 		desc = "Find file",
-- 	},
-- 	-- Telescope live_grep
-- 	{
-- 		"<Leader>fg",
-- 		mode = { "n" },
-- 		"<cmd>Telescope live_grep<CR>",
-- 		desc = "Find grep",
-- 	},
-- 	-- Fzf Files
-- 	{
-- 		"<leader>fF",
-- 		mode = { "n" },
-- 		"<cmd>Files<CR>",
-- 		desc = "Using FzF",
-- 	},
-- 	-- Fzf RG
-- 	{
-- 		"<leader>fR",
-- 		mode = { "n" },
-- 		"<cmd>RG<CR>",
-- 		desc = "Using RG",
-- 	},
-- 	-- Fzf Rg
-- 	{
-- 		"<leader>fr",
-- 		mode = { "n" },
-- 		"<cmd>Rg<CR>",
-- 		desc = "Using Rg",
-- 	},
-- 	-- Fzf Ag
-- 	{
-- 		"<leader>fa",
-- 		mode = { "n" },
-- 		"<cmd>Ag<CR>",
-- 		desc = "Using ag",
-- 	},
-- },
-- opts = {
-- 	defaults = {
-- 		mappings = {
-- 			n = {
-- 				["<Esc><Esc>"] = "close",
-- 				["<Esc>"] = false,
-- 			}
-- 		},
-- 	},
-- 	pickers = {
-- 		find_files = {
-- 			theme = "dropdown"
-- 		},
-- 		live_grep = {
-- 			theme = "dropdown"
-- 		}
-- 	},
-- },
--
-- config = function(_,opts)
-- 	local ts = require("telescope")
-- 	ts.setup(opts)
-- 	vim.api.nvim_set_hl(0, "TelescopeSelection", {
-- 		bg = "None",
-- 		bold = true,
-- 		underdashed = true,
-- 		-- underdashed = true,
-- 	})
-- end
-- }
