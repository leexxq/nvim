return {
	---@module 'lazy'
	---@type LazyPluginBase
	"kawre/leetcode.nvim",
	event="VeryLazy",
	build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
	---@module 'leetcode'
	---@type lc.Config
	opts = {
		-- configuration goes here
		cn = { -- leetcode.cn
			enabled = true, ---@type boolean
			translator = true, ---@type boolean
			translate_problems = true, ---@type boolean
		},
		injector = { ---@type table<lc.lang, lc.inject>
			["python3"] = {
			},
			["cpp"] = {
				-- #include<bits/stdc++.h>
				before = {
				},
				after = { [[int main(){}]], },

			},
			["java"] = {
				before = "import java.util.*;",
			},
		},
		keys = {
			toggle = { "<Esc><Esc>", desc = { "toggle current page" } }, ---@type string|string[]
			confirm = { "<CR>" }, ---@type string|string[]

			reset_testcases = "<Leader>r", ---@type string
			use_testcase = "U", ---@type string
			focus_testcases = "H", ---@type string
			focus_result = "L", ---@type string
		},
		hooks = {
			---@type fun()[]
			["enter"] = { function()
				vim.keymap.set("n", "<Leader>lr", ":Leet run<CR>", { desc = "运行代码测试" })
				vim.keymap.set("n", "<Leader>lc", ":Leet console<CR>", { desc = "打开控制台" })
				vim.keymap.set("n", "<Leader>ls", ":Leet submit<CR>", { desc = "提交代码" })
				vim.keymap.set("n", "<Leader>llh", ":Leet list difficulty=hard<CR>", { desc = "打开困难问题列表" })
				vim.keymap.set("n", "<Leader>lls", ":Leet list<CR>", { desc = "打开问题列表" })
				vim.keymap.set("n", "<Leader>lRh", ":Leet random difficulty=hard<CR>", { desc = "随机一个困难问题" })
			end },
			---@type fun(question: lc.ui.Question)[]
			["question_enter"] = {
				function()
					-- :GenRandArr {n} 在当前行生成随机数组 [a1,a2,...,an]
					-- 默认每个元素是 1 到 100 之间的随机整数
					local function GenRandomArray(len, minv, maxv)
						len = tonumber(len)
						minv = tonumber(minv) or 1
						maxv = tonumber(maxv) or 100

						if not len or len <= 0 then
							vim.api.nvim_err_writeln("Length must be > 0")
							return
						end
						if minv > maxv then
							minv, maxv = maxv, minv
						end

						math.randomseed(os.time() + vim.loop.hrtime())
						local t = {}
						for _ = 1, len do
							local val = math.random(minv, maxv)
							t[#t + 1] = tostring(val)
						end
						local text = "[" .. table.concat(t, ",") .. "]"
						vim.api.nvim_set_current_line(text)
					end

					-- 用法：
					-- :GenRandArr 5           => [随机5个 1..100 的数]
					-- :GenRandArr 5 10 20     => [随机5个 10..20 的数]
					vim.api.nvim_create_user_command("GenRandArr", function(opts)
						local args = vim.split(opts.args, "%s+")
						GenRandomArray(args[1], args[2], args[3])
					end, { nargs = "+", complete = nil })
					-- :GenRandStr {len} 在当前行生成一个定长随机字符串，比如 "aZ9k2LmQ"
					-- 可选第二个参数 charset：
					--   letter  只用字母
					--   digit   只用数字
					--   mix     字母 + 数字（默认）
					local function GenRandomString(len, charset)
						len = tonumber(len)
						if not len or len <= 0 then
							vim.api.nvim_err_writeln("Length must be > 0")
							return
						end

						local sets = {
							lower  = "abcdefghijklmnopqrstuvwxyz",
							upper  = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
							letter = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
							digit  = "0123456789",
							mix    = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
						}
						charset = sets[charset] or sets["mix"]

						math.randomseed(os.time() + vim.loop.hrtime())
						local t = {}
						local n = #charset
						for i = 1, len do
							local idx = math.random(1, n)
							t[i] = string.sub(charset, idx, idx)
						end
						local text = '"' .. table.concat(t, "") .. '"'
						vim.api.nvim_set_current_line(text)
					end

					-- 用法：
					-- :GenRandStr 8          => 生成 8 位字母数字混合字符串
					-- :GenRandStr 16 letter  => 16 位纯字母
					-- :GenRandStr 6 digit    => 6 位纯数字
					vim.api.nvim_create_user_command("GenRandStr", function(opts)
						local args = vim.split(opts.args, "%s+")
						GenRandomString(args[1], args[2])
					end, { nargs = "+" })
				end

			},

			---@type fun()[]
			["leave"] = {
				function()
				end
			},
		},
	},
}
