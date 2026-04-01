-- LSPs list
local servers = {
	"lua_ls",
	"basedpyright",
	"clangd",
	"csharp_ls",
}

return {
	"mason-org/mason-lspconfig.nvim",
	opts = {
		automatic_enable = servers
	},
	dependencies = {
		{
			"mason-org/mason.nvim",
			event="VeryLazy",
			opts = {
				ui = {
					border = "rounded"
				}

			}
		},

		{
			"neovim/nvim-lspconfig",
		}
	},
}
