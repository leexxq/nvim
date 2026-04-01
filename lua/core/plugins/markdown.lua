return {
	'MeanderingProgrammer/render-markdown.nvim',
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
	dependencies = {
		'nvim-treesitter/nvim-treesitter',
		'echasnovski/mini.nvim',
		'echasnovski/mini.icons',
		'nvim-tree/nvim-web-devicons',
		{
			-- install without yarn or npm
			"iamcco/markdown-preview.nvim",
			cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
			ft = { "markdown" },
			build = function() vim.fn["mkdp#util#install"]() end,
		}
	},
}
