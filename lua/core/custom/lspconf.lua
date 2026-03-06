-- used custom lsp conf in vim running
-- diagnostic UI touches
vim.diagnostic.config {
	-- virtual_lines = { current_line = true },
	virtual_text = {
		spacing = 5,
		prefix = '◍ ',
	},
	float = { severity_sort = true },
	severity_sort = true,
	signs = {
		text = {
			-- [vim.diagnostic.severity.ERROR] = '',
			[vim.diagnostic.severity.ERROR] = '',
			[vim.diagnostic.severity.WARN] = '',
			[vim.diagnostic.severity.INFO] = '',
			[vim.diagnostic.severity.HINT] = '',
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = 'DiagnosticError',
			[vim.diagnostic.severity.WARN] = 'DiagnosticWarning',
			[vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
			[vim.diagnostic.severity.HINT] = 'DiagnosticHint',
		},
	},
}

local api, lsp = vim.api, vim.lsp
api.nvim_create_user_command('LspInfo', ':checkhealth vim.lsp', { desc = 'Alias to `:checkhealth vim.lsp`' })
api.nvim_create_user_command('LspLog', function()
	vim.cmd(string.format('tabnew %s', lsp.get_log_path()))
end, {
	desc = 'Opens the Nvim LSP client log.',
})

local complete_client = function(arg)
	return vim
		.iter(vim.lsp.get_clients())
		:map(function(client)
			return client.name
		end)
		:filter(function(name)
			return name:sub(1, #arg) == arg
		end)
		:totable()
end

api.nvim_create_user_command('LspRestart', function(info)
	for _, name in ipairs(info.fargs) do
		if vim.lsp.config[name] == nil then
			vim.notify(("Invalid server name '%s'"):format(info.args))
		else
			vim.lsp.enable(name, false)
		end
	end


	local timer = assert(vim.uv.new_timer())
	timer:start(500, 0, function()
		for _, name in ipairs(info.fargs) do
			vim.schedule_wrap(function(x)
				vim.lsp.enable(x)
			end)(name)
		end
	end)
end, {
	desc = 'Restart the given client(s)',
	nargs = '+',
	complete = complete_client,
})
