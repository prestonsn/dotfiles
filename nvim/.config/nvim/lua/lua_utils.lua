local M = {}

function M.exec_lua()
	local code = ""
	local mode = vim.fn.mode()

	if mode:match("v") then
		local start_line = vim.fn.line("'<")
		local end_line = vim.fn.line("'>")
		local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
		code = table.concat(lines, "\n")
	else
		local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
		code = table.concat(lines, "\n")
	end

	local chunk, err = load(code)
	if not chunk then
		print("Lua error: " .. err)
		return
	end

	local output = {}
	local original_print = print
	print = function(...)
		local strs = {}
		for _, v in ipairs({ ... }) do
			table.insert(strs, tostring(v))
		end
		local message = table.concat(strs, " ")
		table.insert(output, message)
	end

	local ok, result = pcall(chunk)

	print = original_print

	if not ok then
		table.insert(output, "Execution error: " .. result)
	else
		table.insert(output, "Executed successfully")
	end


	vim.cmd('vnew')
	local new_buf = vim.api.nvim_get_current_buf()
	vim.bo[new_buf].bufhidden = 'wipe'
	vim.api.nvim_buf_set_lines(new_buf, 0, -1, false, output)
	vim.bo[new_buf].modified = false
end

return M
