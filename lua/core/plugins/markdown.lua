return {
	'MeanderingProgrammer/render-markdown.nvim',
	dependencies = {
		'nvim-treesitter/nvim-treesitter',
		'echasnovski/mini.nvim',
		'echasnovski/mini.icons',
		'nvim-tree/nvim-web-devicons',
		{
			"iamcco/markdown-preview.nvim",
			cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
			event = "VeryLazy",
			build = "cd app && yarn install",
			init = function()
				vim.g.mkdp_filetypes = { "markdown" }
			end,
			ft = { "markdown" },
		}
	},

	event = "VeryLazy",
	opts = {
		file_types = { 'markdown', 'codecompanion' },
		heading = {
			backgrounds = {
				'RenderMarkdownH1',
				'RenderMarkdownH2',
				'RenderMarkdownH3',
				'RenderMarkdownH4',
				'RenderMarkdownH5',
				'RenderMarkdownH6',
				-- 'DiffRemoved',
				-- 'DiffChanged',
				-- 'DiffAdded',
				-- 'DiffFile',
				-- 'DiffOldfile',
				-- 'DiffLine',
			},
		},
		code = {
			language_border = ' ',
		}
	},
}
