local M = {}

-- Local function to create a new buffer with provided lines.
-- It splits any string with newline characters into separate lines.
local function open_output_buffer(lines)
	local processed_lines = {}
	for _, line in ipairs(lines) do
		local split_lines = vim.split(line, "\n")
		for _, subline in ipairs(split_lines) do
			table.insert(processed_lines, subline)
		end
	end
	vim.cmd('vnew')
	local new_buf = vim.api.nvim_get_current_buf()
	vim.bo[new_buf].bufhidden = 'wipe'
	vim.api.nvim_buf_set_lines(new_buf, 0, -1, false, processed_lines)
	vim.bo[new_buf].modified = false
end

-- Define function to execute Lua code from selection or entire file
function M.exec_lua()
	-- Initialize code string, get current mode and buffer
	local code = ""
	local mode = vim.fn.mode()
	local current_buf = vim.api.nvim_get_current_buf()

	-- If in visual mode, get selected lines; otherwise, get entire buffer content
	if mode:match("v") then
		local start_line = vim.fn.line("'<")
		local end_line = vim.fn.line("'>")
		local lines = vim.api.nvim_buf_get_lines(current_buf, start_line - 1, end_line, false)
		code = table.concat(lines, "\n")
	else
		local lines = vim.api.nvim_buf_get_lines(current_buf, 0, -1, false)
		code = table.concat(lines, "\n")
	end

	-- Attempt to load the Lua code and handle any syntax errors
	local chunk, err = load(code)
	if not chunk then
		vim.notify("Lua error: " .. err, vim.log.levels.ERROR)
		return
	end

	-- Set up output capture by overriding print function
	local output = {}
	local original_print = print

	local function custom_print(...)
		local strs = {}
		for _, v in ipairs({ ... }) do
			table.insert(strs, tostring(v))
		end
		table.insert(output, table.concat(strs, " "))
	end

	print = custom_print

	-- Execute the loaded Lua code safely
	local ok, result = xpcall(chunk, debug.traceback)

	-- Restore the original print function
	print = original_print

	-- Process output depending on execution result
	if not ok then
		-- In case of error, capture the error message and open buffer to display error output
		table.insert(output, "Execution error: " .. result)
		open_output_buffer(output)
	else
		-- If execution succeeded, only open a new buffer if there is output; otherwise, notify success
		if next(output) then
			open_output_buffer(output)
		else
			vim.notify("Executed successfully", vim.log.levels.INFO)
		end
	end
end

return M
