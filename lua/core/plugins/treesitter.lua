return {
	'nvim-treesitter/nvim-treesitter',
	build = ":TSUpdate",
	lazy = false,
	-- config = function()
	-- 	require('nvim-treesitter.configs').setup({
	-- 		-- A list of parser names, or "all"
	-- 		ensure_installed = { "lua", "c_sharp", "bash", "regex" },
	-- 		-- Automatically install missing parsers when entering buffer
	-- 		auto_install = true,
	-- 		highlight = {
	-- 			enable = true,
	-- 		}
	-- 	})
	-- end
}
