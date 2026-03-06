return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup {
			border = "rounded",
			sources = {
				-- null_ls.builtins.formatting.stylua, --lua
				-- null_ls.builtins.formatting.csharpier, --c#
				-- null_ls.builtins.formatting.black --python
				-- null_ls.builtins.formatting.clang_format.with({
				-- 	-- extra_args = {
				-- 	-- 	-- 如果你想完全忽略 .clang-format，使用下面的方式：
				-- 	-- 	-- 注意：不同 clang-format 版本对 "file" 是否必须有些差异，如遇问题可删除 BasedOnStyle 行，全部显式写出
				-- 	-- 	-- 这是godot 引擎的 clang-format 配置，基于 LLVM 风格，适用于 C++ 和 C#，你可以根据需要进行调整。
				-- 	-- 	"--style={
				-- 	--
				-- 	-- 	}",
				-- 	-- }
				-- }), --c/c++
			}
		}
	end
}
