return {
	{
		'sainnhe/gruvbox-material',
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.gruvbox_material_enable_italic = true
			if vim.fn.has('termguicolors') then
				vim.opt.termguicolors = true
			end
			-- vim.g.gruvbox_material_background = 'hard'
			vim.g.gruvbox_material_better_performance = 1
			vim.g.gruvbox_material_transparent_background = 2

			vim.opt.cursorline = true
			vim.opt.cursorlineopt = "both" -- 同时高亮行号和行

			-- 在加载 colorscheme 之前创建 autocmd，使用 gruvbox-material 官方提供的接口
			vim.api.nvim_create_autocmd('ColorScheme', {
				group = vim.api.nvim_create_augroup('custom_highlights_gruvboxmaterial', { clear = true }),
				pattern = 'gruvbox-material',
				callback = function()
					-- 获取 gruvbox-material 当前的配置与调色板
					local config = vim.fn['gruvbox_material#get_configuration']()
					local palette = vim.fn['gruvbox_material#get_palette'](config.background, config.foreground,
						config.colors_override)
					local set_hl = vim.fn['gruvbox_material#highlight']

					-- 官方 set_hl 函数签名: set_hl(group, fg, bg, style)
					-- 颜色格式必须是 { "gui_hex", "cterm_color" }
					local main_white = { "#ffffff", "231" }
					local normal_float_fg = { "#ddc7a1", "223" }

					-- 当前行：透明背景 + 斜体
					set_hl('CursorLine', palette.none, palette.none, 'italic')
					-- 当前行号：亮白 + 加粗
					set_hl('CursorLineNr', main_white, palette.none, 'bold')

					-- Visual 模式：透明背景 + 斜体 + 双下划线 + 加粗
					set_hl('Visual', palette.none, palette.none, 'italic,underdouble,bold')

					-- 浮动窗口相关
					set_hl('NormalFloat', normal_float_fg, palette.none)
					set_hl('ColorColumn', palette.none, palette.none)
					set_hl('FloatBorder', palette.none, palette.none)
					set_hl('FloatTitle', palette.none, palette.none)

					-- Tabline 标签页 (提取了调色板自带的灰色与橙色，比直接用字符串 "grey"/"Orange" 更协调)
					set_hl('TabLine', palette.grey2, palette.none)
					set_hl('TabLineSel', palette.orange, palette.none)

					-- Pmenu 补全菜单 (保留了文字前景色 palette.fg1，其余背景设为透明)
					set_hl('Pmenu', palette.fg1, palette.none)
					set_hl('PmenuSel', palette.fg1, palette.none, 'italic,underline,bold')
					set_hl('PmenuExtra', palette.grey2, palette.none)
					set_hl('PmenuKind', palette.green, palette.none)

					-- Git Diff
					set_hl('DiffAdd', palette.none, palette.none, 'bold,underdashed')
				end
			})

			-- 必须在声明好上述 autocmd 之后再应用主题
			vim.cmd.colorscheme("gruvbox-material")
		end
	},
	-- {
	-- 	'sainnhe/gruvbox-material',
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		-- Optionally configure and load the colorscheme
	-- 		-- directly inside the plugin declaration.
	-- 		vim.g.gruvbox_material_enable_italic = true
	-- 		if vim.fn.has('termguicolors') then
	-- 			vim.opt.termguicolors = true;
	-- 		end
	-- 		-- vim.g.gruvbox_material_background = 'hard'
	-- 		vim.g.gruvbox_material_better_performance = 1
	-- 		vim.g.gruvbox_material_transparent_background = 2
	--
	-- 		vim.opt.termguicolors = true
	-- 		vim.opt.cursorline = true
	-- 		vim.opt.cursorlineopt = "both" -- 同时高亮行号和行
	--
	-- 		local function set_hl()
	-- 			-- 主白色 + 柔光渐变
	-- 			local main_white = "#ffffff"
	--
	-- 			-- 当前行：透明背景 + 双层下划线（近似渐变）
	-- 			vim.api.nvim_set_hl(0, "CursorLine", {
	-- 				bg = "NONE",
	-- 				italic = true,
	-- 			})
	--
	-- 			-- 当前行号：亮白 + 加粗
	-- 			vim.api.nvim_set_hl(0, "CursorLineNr", {
	-- 				fg = main_white,
	-- 				bg = "NONE",
	-- 			})
	--
	-- 			vim.api.nvim_set_hl(0, "Visual", {
	-- 				bg = "NONE",
	-- 				italic = true,
	-- 				underdouble = true,
	-- 				bold = true,
	-- 			})
	--
	-- 			vim.api.nvim_set_hl(0, "NormalFloat", {
	-- 				ctermfg = 223,
	-- 				ctermbg = "NONE",
	-- 				-- fg = "#ddc7a1",
	-- 				-- bg = "NONE"
	-- 			})
	--
	-- 			vim.api.nvim_set_hl(0, "ColorColumn", {
	-- 				bg = "NONE",
	-- 			})
	-- 			vim.api.nvim_set_hl(0, "FloatBorder", {
	-- 				bg = "NONE",
	-- 			})
	--
	-- 			vim.api.nvim_set_hl(0, "FloatTitle", {
	-- 				bg = "NONE",
	-- 			})
	--
	-- 			vim.api.nvim_set_hl(0, "TabLine", {
	-- 				bg = "NONE",
	-- 				fg = "grey",
	-- 				-- underline = true
	-- 			})
	-- 			vim.api.nvim_set_hl(0, "TabLineSel", {
	-- 				bg = "NONE",
	-- 				fg = "Orange",
	-- 				-- underdashed = true,
	-- 			})
	-- 			vim.api.nvim_set_hl(0, "Pmenu", {
	-- 				bg = "NONE",
	-- 				-- underdashed = true,
	-- 			})
	-- 			vim.api.nvim_set_hl(0, "PmenuSel", {
	-- 				bg = "NONE",
	-- 				italic = true,
	-- 				underline = true,
	-- 				bold = true,
	-- 			})
	-- 			vim.api.nvim_set_hl(0, "PmenuExtra", {
	-- 				bg = "NONE",
	-- 				-- underdashed = true,
	-- 			})
	-- 			vim.api.nvim_set_hl(0, "PmenuKind", {
	-- 				bg = "NONE",
	-- 				-- underdashed = true,
	-- 			})
	--
	-- 			vim.api.nvim_set_hl(0, "DiffAdd", {
	-- 				bg = "None",
	-- 				bold = true,
	-- 				underdashed = true,
	-- 				-- underdashed = true,
	-- 			})
	-- 		end
	--
	-- 		vim.cmd.colorscheme("gruvbox-material")
	-- 		set_hl()
	-- 		vim.api.nvim_create_autocmd("ColorScheme", { callback = set_hl })
	-- 		--
	-- 	end
	-- },

	{
		'AlexvZyl/nordic.nvim',
		lazy = true,
		-- priority = 1000,
		-- config = function()
		-- 	require('nordic').load()
		-- end
	},
}
