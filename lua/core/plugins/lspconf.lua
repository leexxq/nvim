-- LSPs list
-- local servers = {
-- 	"lua_ls",
-- 	-- "pylsp",
-- 	-- "clangd",
-- 	-- "csharp_ls",
-- }

return {
	"mason-org/mason-lspconfig.nvim",
	opts = {},
	dependencies = {
		{
			"mason-org/mason.nvim",
			opts = {

				ui = {
					border = "rounded"
				}

			}
		},

		"neovim/nvim-lspconfig",
	},
}
