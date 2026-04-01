return {
	{
		"mfussenegger/nvim-dap",
		event = "VeryLazy",
		dependencies = {
			-- lua debugger
			"jbyuki/one-small-step-for-vimkind",
		},
		config = function()
			-- code
			local dap = require('dap')
			-- keymap
			vim.keymap.set('n', '<leader>dB', require "dap".toggle_breakpoint,
				{ noremap = true, desc = "toggle breakpoint" })
			vim.keymap.set('n', '<leader>dC', require "dap".continue, { noremap = true, desc = "debug continue" })
			vim.keymap.set('n', '<leader>dn', require "dap".step_over, { noremap = true, desc = "step over" })
			vim.keymap.set('n', '<leader>di', require "dap".step_into, { noremap = true, desc = "setp into " })
			vim.keymap.set('n', '<leader>do', require "dap".step_out, { noremap = true, desc = "setp out " })
			vim.keymap.set('n', '<leader>dL', function()
				require "osv".launch({ port = 8086 })
			end, { noremap = true, desc = "launch lua server" })

			-- lua debug config
			dap.configurations.lua = {
				{
					type = 'nlua',
					request = 'attach',
					name = "Attach to running Neovim instance",
				}
			}
			dap.adapters.nlua = function(callback, config)
				callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
			end


			--codelldb debugger
			dap.adapters.codelldb = {
				type = "executable",
				command = "codelldb", -- or if not in $PATH: "/absolute/path/to/codelldb"
				-- On windows you may have to uncomment this:
				-- detached = false,
			}

			--cpp debug config
			dap.configurations.cpp = {
				{
					name = "Build and launch current file",
					type = "codelldb",
					request = "launch",
					program = function()
						-- -- Runs synchronously:
						-- local obj = vim.system({ 'echo', 'hello' }, { text = true }):wait()
						local file        = vim.fn.expand("%:p");
						local output_file = vim.fn.expand("%:p:r");
						local obj         = vim.system(
							{ 'g++', '-std=c++23', '-Wall', '-g', file, '-o', output_file },
							{ text = true }):wait()
						if obj.stderr ~= nil and obj.stderr ~= '' then
							vim.notify(obj.stderr, vim.log.levels.ERROR)
							return nil
						end
						return output_file
					end,
					cwd = '${workspaceFolder}',
					stopOnEntry = false,
				},

				{
					name = "Launch exec",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
					end,
					cwd = '${workspaceFolder}',
					stopOnEntry = false,
				},

			}
			-- Helper function to find Godot project file and directory
			local function find_godot_project()
				-- Create cache to avoid repeated lookups
				if not _G.godot_project_cache then
					_G.godot_project_cache = {}
				end

				-- Start with current working directory
				local current_dir = vim.fn.getcwd()

				-- Check cache first
				if _G.godot_project_cache[current_dir] then
					return _G.godot_project_cache[current_dir].file_path, _G.godot_project_cache[current_dir].dir_path
				end

				-- Function to check if a directory contains a project.godot file
				local function has_project_file(dir)
					local project_file = dir .. '/project.godot'
					local stat = vim.uv.fs_stat(project_file)
					if stat and stat.type == 'file' then
						return project_file, dir
					else
						return nil, nil
					end
				end

				-- Check current directory first
				local project_file, project_dir = has_project_file(current_dir)
				if project_file then
					_G.godot_project_cache[current_dir] = { file_path = project_file, dir_path = project_dir }
					vim.notify('Found Godot project at: ' .. project_file, vim.log.levels.INFO)
					return project_file, project_dir
				end

				-- Search in parent directories up to a reasonable limit
				local max_depth = 5
				local dir = current_dir

				for i = 1, max_depth do
					-- Get parent directory
					local parent = vim.fn.fnamemodify(dir, ':h')

					-- Stop if we've reached the root
					if parent == dir then
						break
					end

					dir = parent

					-- Check if this directory has a project.godot file
					local project_file, project_dir = has_project_file(dir)
					if project_file then
						_G.godot_project_cache[current_dir] = { file_path = project_file, dir_path = project_dir }
						vim.notify('Found Godot project in parent directory: ' .. project_file, vim.log.levels.INFO)
						return project_file, project_dir
					end
				end

				-- Search in immediate subdirectories (first level only)
				local handle = vim.uv.fs_scandir(current_dir)
				if handle then
					while true do
						local name, type = vim.uv.fs_scandir_next(handle)
						if not name then
							break
						end

						-- Only check directories
						if type == 'directory' then
							local subdir = current_dir .. '/' .. name
							local project_file, project_dir = has_project_file(subdir)
							if project_file then
								_G.godot_project_cache[current_dir] = { file_path = project_file, dir_path = project_dir }
								vim.notify('Found Godot project in subdirectory: ' .. project_file, vim.log.levels.INFO)
								return project_file, project_dir
							end
						end
					end
				end

				-- If still not found, ask the user
				local input_dir = vim.fn.input('Godot project directory: ', current_dir, 'dir')

				-- Validate the input path
				if input_dir ~= '' then
					local project_file, project_dir = has_project_file(input_dir)
					if project_file then
						_G.godot_project_cache[current_dir] = { file_path = project_file, dir_path = project_dir }
						return project_file, project_dir
					end
				end

				vim.notify('No valid Godot project found. Using current directory.', vim.log.levels.WARN)
				return current_dir .. '/project.godot', current_dir
			end

			-- Function to debug and print the full command that will be executed
			local function debug_command(executable, args)
				local full_command = executable
				for _, arg in ipairs(args) do
					-- Properly quote arguments with spaces
					if arg:find ' ' then
						full_command = full_command .. ' "' .. arg .. '"'
					else
						full_command = full_command .. ' ' .. arg
					end
				end

				local debug_msg = 'Executing: ' .. full_command
				vim.notify(debug_msg, vim.log.levels.INFO)
				vim.notify(debug_msg)

				-- Debug environment info
				vim.notify('Current working directory: ' .. vim.fn.getcwd())
				vim.notify('HOME env: ' .. (os.getenv 'HOME' or 'not set'))
				vim.notify('DISPLAY env: ' .. (os.getenv 'DISPLAY' or 'not set'))
				vim.notify('XDG_SESSION_TYPE env: ' .. (os.getenv 'XDG_SESSION_TYPE' or 'not set'))

				return args
			end

			-- Path to the Godot executable
			local godot_executable =
			'C:/Users/27346/Documents/Godot_v4.3-stable_mono_win64/Godot_v4.3-stable_mono_win64/Godot_v4.3-stable_mono_win64.exe'

			-- Get important environment variables
			local function get_env_vars()
				return {
					-- Graphics-related variables (crucial for GUI apps)
					DISPLAY = os.getenv 'DISPLAY' or ':0',
					WAYLAND_DISPLAY = os.getenv 'WAYLAND_DISPLAY',
					XDG_SESSION_TYPE = os.getenv 'XDG_SESSION_TYPE',
					XAUTHORITY = os.getenv 'XAUTHORITY',

					-- Audio-related variables
					PULSE_SERVER = os.getenv 'PULSE_SERVER',

					-- User-related variables
					HOME = os.getenv 'HOME',
					USER = os.getenv 'USER',
					LOGNAME = os.getenv 'LOGNAME',

					-- Path-related variables
					PATH = os.getenv 'PATH',
					LD_LIBRARY_PATH = os.getenv 'LD_LIBRARY_PATH',

					-- Locale variables
					LANG = os.getenv 'LANG' or 'en_US.UTF-8',
					LC_ALL = os.getenv 'LC_ALL',

					-- XDG variables
					XDG_RUNTIME_DIR = os.getenv 'XDG_RUNTIME_DIR',
					XDG_DATA_HOME = os.getenv 'XDG_DATA_HOME',
					XDG_CONFIG_HOME = os.getenv 'XDG_CONFIG_HOME',

					-- Other potentially relevant variables
					SHELL = os.getenv 'SHELL',
					TERM = os.getenv 'TERM',
					DBUS_SESSION_BUS_ADDRESS = os.getenv 'DBUS_SESSION_BUS_ADDRESS',
				}
			end

			-- Standard GDScript adapter for non-C# projects
			dap.adapters.godot = {
				type = 'server',
				host = '127.0.0.1',
				port = 6006,
			}

			dap.configurations.gdscript = {
				{
					type = 'godot',
					request = 'launch',
					name = 'Launch Scene',
					project = '${workspaceFolder}',
					launch_scene = true,
				},
			}

			-- Direct launch approach using netcoredbg to start Godot-Mono
			dap.adapters.coreclr = {
				type = 'executable',
				command = "C:/Users/27346/scoop/apps/NetCoreDbg/current/netcoredbg.exe",
				args = {
					'--interpreter=vscode',
					'--',
					godot_executable,
				},
			}

			dap.configurations.cs = {
				-- Launch Godot editor with project - simple approach
				{
					type = 'coreclr',
					request = 'launch',
					name = 'Simple Editor Launch',
					cwd = function()
						local project_file, project_dir = find_godot_project()
						vim.notify("cwd " .. project_dir)
						return project_dir
					end,
					env = get_env_vars(), -- Pass environment variables
					args = function()
						local project_file, project_dir = find_godot_project()
						return { " --editor " .. project_file }
					end,
				},
			}
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		event = "VeryLazy",
		dependencies = {  "nvim-neotest/nvim-nio" },
		config = function()
			require("lazydev").setup({
				library = { "nvim-dap-ui" },
			})
			local dap, dapui = require("dap"), require("dapui")
			dapui.setup()
			dap.listeners.before.attach.dapui_config = function()
				vim.notify_once("Attach success!")
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				vim.notify_once("Launch success!")
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				vim.notify_once("Debug Terminated!")
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				vim.notify_once("Debug End!")
				dapui.close()
			end
		end
	},
	{

		"theHamsta/nvim-dap-virtual-text",
		event = "VeryLazy",
		opts = {

			enabled = true,            -- enable this plugin (the default)
			enabled_commands = true,   -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
			highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
			highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
			show_stop_reason = true,   -- show stop reason when stopped for exceptions
			commented = false,         -- prefix virtual text with comment string
			only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
			all_references = false,    -- show virtual text on all all references of the variable (not only definitions)
			clear_on_continue = false, -- clear virtual text on "continue" (might cause flickering when stepping)
			--- A callback that determines how a variable is displayed or whether it should be omitted
			--- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
			--- @param buf number
			--- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
			--- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
			--- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
			--- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
			display_callback = function(variable, buf, stackframe, node, options)
				-- by default, strip out new line characters
				if options.virt_text_pos == 'inline' then
					return ' = ' .. variable.value:gsub("%s+", " ")
				else
					return variable.name .. ' = ' .. variable.value:gsub("%s+", " ")
				end
			end,
			-- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
			virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',

			-- experimental features:
			all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
			virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
			virt_text_win_col = nil -- position the virtual text at a fixed window column (starting from the first text column) ,
			-- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
		},
	}
}
