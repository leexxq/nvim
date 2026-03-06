return {
	{
		'sainnhe/gruvbox-material',
		lazy = false,
		priority = 1000,
		config = function()
			-- Optionally configure and load the colorscheme
			-- directly inside the plugin declaration.
			vim.g.gruvbox_material_enable_italic = true
			if vim.fn.has('termguicolors') then
				vim.opt.termguicolors = true;
			end
			-- vim.g.gruvbox_material_background = 'hard'
			vim.g.gruvbox_material_better_performance = 1
			vim.g.gruvbox_material_transparent_background = 2

			vim.opt.termguicolors = true
			vim.opt.cursorline = true
			vim.opt.cursorlineopt = "both" -- 同时高亮行号和行

			local function set_hl()
				-- 主白色 + 柔光渐变
				local main_white = "#ffffff"

				-- 当前行：透明背景 + 双层下划线（近似渐变）
				vim.api.nvim_set_hl(0, "CursorLine", {
					bg = "NONE",
					italic = true,
				})

				-- 当前行号：亮白 + 加粗
				vim.api.nvim_set_hl(0, "CursorLineNr", {
					fg = main_white,
					bg = "NONE",
				})

				vim.api.nvim_set_hl(0, "Visual", {
					bg = "NONE",
					italic = true,
					underdouble = true,
					bold = true,
				})

				vim.api.nvim_set_hl(0, "NormalFloat", {
					ctermfg = 223,
					ctermbg = "NONE",
					-- fg = "#ddc7a1",
					-- bg = "NONE"
				})

				vim.api.nvim_set_hl(0, "ColorColumn", {
					bg = "NONE",
				})
				vim.api.nvim_set_hl(0, "FloatBorder", {
					bg = "NONE",
				})

				vim.api.nvim_set_hl(0, "FloatTitle", {
					bg = "NONE",
				})

				vim.api.nvim_set_hl(0, "TabLine", {
					bg = "NONE",
					fg = "grey",
					-- underline = true
				})
				vim.api.nvim_set_hl(0, "TabLineSel", {
					bg = "NONE",
					fg = "Orange",
					-- underdashed = true,
				})
				vim.api.nvim_set_hl(0, "Pmenu", {
					bg = "NONE",
					-- underdashed = true,
				})
				vim.api.nvim_set_hl(0, "PmenuSel", {
					bg = "NONE",
					italic = true,
					underline = true,
					bold = true,
				})
				vim.api.nvim_set_hl(0, "PmenuExtra", {
					bg = "NONE",
					-- underdashed = true,
				})
				vim.api.nvim_set_hl(0, "PmenuKind", {
					bg = "NONE",
					-- underdashed = true,
				})

				vim.api.nvim_set_hl(0, "DiffAdd", {
					bg = "None",
					bold = true,
					underdashed = true,
					-- underdashed = true,
				})
			end

			vim.cmd.colorscheme("gruvbox-material")
			set_hl()
			vim.api.nvim_create_autocmd("ColorScheme", { callback = set_hl })
			--
		end
	},

	{
		'AlexvZyl/nordic.nvim',
		lazy = true,
		-- priority = 1000,
		-- config = function()
		-- 	require('nordic').load()
		-- end
	},
}
