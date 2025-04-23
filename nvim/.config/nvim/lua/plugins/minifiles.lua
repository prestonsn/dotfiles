-- Set focused directory as current working directory
local set_cwd = function()
	local minifiles = require('mini.files')
	local path = (minifiles.get_fs_entry() or {}).path
	if path == nil then return vim.notify('Cursor is not on valid entry') end
	vim.fn.chdir(vim.fs.dirname(path))
	minifiles.trim_left()
end

--- Yank in register path of entry under cursor.
---@param rel_path boolean Yank relative path if true, full path otherwise.
local yank_path = function(rel_path)
	local minifiles = require('mini.files')
	local path = (minifiles.get_fs_entry() or {}).path
	if path == nil then return vim.notify('Cursor is not on valid entry') end
	if rel_path then
		path = vim.fn.fnamemodify(path, ':.')
	end
	vim.fn.setreg(vim.v.register, path)
end

-- Open path with system default handler (useful for non-text files)
local ui_open = function()
	local minifiles = require('mini.files')
	vim.ui.open(minifiles.get_fs_entry().path)
end

local luv = vim.loop
-- Function to recursively add files in a directory to chat references
local function traverse_directory(path, chat)
	local handle, err = luv.fs_scandir(path)
	if not handle then return print("Error scanning directory: " .. err) end

	while true do
		local name, type = luv.fs_scandir_next(handle)
		if not name then break end

		local item_path = path .. "/" .. name
		if type == "file" then
			-- add the file to references
			chat.references:add({
				id = '<file>' .. item_path .. '</file>',
				path = item_path,
				source = "codecompanion.strategies.chat.slash_commands.file",
				opts = {
					pinned = true
				}
			})
		elseif type == "directory" then
			-- recursive call for a subdirectory
			traverse_directory(item_path, chat)
		end
	end
end

-- Function to add the current file or directory (all files recursively) to Code Companion
local add_to_code_companion = function()
	local minifiles = require('mini.files')
	local path = minifiles.get_fs_entry().path
	local codecompanion = require("codecompanion")
	local chat = codecompanion.last_chat()
	-- create chat if none exists
	if (chat == nil) then
		chat = codecompanion.chat()
	end

	local attr = luv.fs_stat(path)
	if attr and attr.type == "directory" then
		-- Recursively traverse the directory
		traverse_directory(path, chat)
	else
		-- if already added, ignore
		for _, ref in ipairs(chat.refs) do
			if ref.path == path then
				return print("Already added")
			end
		end
		chat.references:add({
			id = '<file>' .. path .. '</file>',
			path = path,
			source = "codecompanion.strategies.chat.slash_commands.file",
			opts = {
				pinned = true
			}
		})
	end
end

return {
	'echasnovski/mini.files',
	lazy = false,
	keys = {
		{ '<leader>b', function() require('mini.files').open(vim.api.nvim_buf_get_name(0)) end, desc = 'Browse Files' },
		{
			'<leader>B',
			function() require('mini.files').open() end,
			desc = 'Browse Files at CWD'
		},
	},
	config = function()
		vim.api.nvim_create_autocmd('User', {
			pattern = 'MiniFilesBufferCreate',
			callback = function(args)
				local b = args.data.buf_id
				vim.keymap.set('n', 'g.', set_cwd, { buffer = b, desc = 'Set cwd' })
				vim.keymap.set('n', 'gX', ui_open, { buffer = b, desc = 'OS open' })
				vim.keymap.set('n', 'gy', function() yank_path(true) end,
					{ buffer = b, desc = 'Yank relative path' })
				vim.keymap.set('n', 'gY', function() yank_path(false) end,
					{ buffer = b, desc = 'Yank full path' })
				vim.keymap.set('n', 'gC', add_to_code_companion,
					{ buffer = b, desc = 'Add to Code Companion' })
			end,
		})
	end,
}
