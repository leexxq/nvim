vim.api.nvim_create_autocmd("RecordingEnter", {
	callback = function()
		StartRecordingMacro()
	end,
})

function StartRecordingMacro()
	vim.notify("正在录制宏...", vim.log.levels.INFO, {
		timeout = false,
	})
	vim.cmd("autocmd RecordingLeave * lua StopRecordingMacro()")
end

function StopRecordingMacro()
	Snacks.notifier.hide()
	vim.notify("宏录制完成！", vim.log.levels.INFO, {
		timeout = 1000,
	})
end

--CodeCompanionHooks
local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

vim.api.nvim_create_autocmd({ "User" }, {
	group = group,
	callback = function(request)
		if request.match == "CodeCompanionChatCreated" then
			-- Format the buffer after the inline request has completed
			vim.notify("创建成功！", vim.log.levels.INFO, { timeout = 1000 })
		end

		if request.match == "CodeCompanionRequestStarted" then
			vim.notify("AI 正在思考中...", vim.log.levels.INFO, { timeout = false })
		end

		if request.match == "CodeCompanionRequestFinished" then
			vim.dismiss()
			vim.notify("AI 思考完成!", vim.log.levels.INFO, { timeout = 1000 })
		end
	end,
})
