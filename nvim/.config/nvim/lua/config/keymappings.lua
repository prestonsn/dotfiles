-- Larger increments for window resizing
vim.keymap.set({ 'n' }, "<C-w><", "5<C-w><", { noremap = true, desc = "Decrease width" })
vim.keymap.set({ 'n' }, "<C-w>>", "5<C-w>>", { noremap = true, desc = "Increase width" })
vim.keymap.set({ 'n' }, "<C-w>-", "5<C-w>-", { noremap = true, desc = "Decrease height" })
vim.keymap.set({ 'n' }, "<C-w>+", "5<C-w>+", { noremap = true, desc = "Increase height" })

-- LSP inlay hint toggle
vim.keymap.set({ 'n' }, '\\z', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({})) end,
	{ desc = 'Toggle lsp inlay hints' })

-- Map up/down arrow for autocompletion selection in command mode
vim.keymap.set({ 'c' }, '<Up>', "<C-p>", { desc = 'Select previous' })
vim.keymap.set({ 'c' }, '<Down>', "<C-n>", { desc = 'Select next' })

vim.keymap.set({ 'n' }, '<leader><f1>', function() vim.cmd.RustLsp('openDocs') end, { desc = 'Open Rust Doc' })

vim.keymap.set({ 'n' }, "<leader>ff", function() require('fzf-lua').files() end, { desc = "Find File" })
vim.keymap.set({ 'n' }, "<leader>fF", function() require('fzf-lua').oldfiles() end, { desc = "Previous Files" })
vim.keymap.set({ 'n' }, "<leader>fg", function() require('fzf-lua').live_grep() end, { desc = "Live Grep" })
vim.keymap.set({ 'n' }, "<leader>fb", function() require('fzf-lua').buffers() end, { desc = "Find Buffer" })
vim.keymap.set({ 'n' }, "<leader>fz", function() require('fzf-lua').blines() end, { desc = "Buffer Fuzzy Find" })
vim.keymap.set({ 'n' }, "<leader>f?", function() require('fzf-lua').helptags() end, { desc = "Find Help" })
vim.keymap.set({ 'n' }, "<leader>fw", function() require('fzf-lua').grep_cword() end, { desc = "Grep Word Under Cursor" })
vim.keymap.set({ 'n' }, "<leader>fr", function() require('fzf-lua').lsp_references() end, { desc = "Find References" })
vim.keymap.set({ 'n' }, "<leader>fs", function() require('fzf-lua').lsp_document_symbols() end,
	{ desc = "Document Symbols" })
vim.keymap.set({ 'n' }, "<leader>fS", function() require('fzf-lua').lsp_workspace_symbols() end,
	{ desc = "Workspace Symbols" })
vim.keymap.set({ 'n' }, "<leader>fq", function() require('fzf-lua').diagnostics_workspace() end,
	{ desc = "LSP Diagnostics" })
vim.keymap.set({ 'n' }, "<leader>f:", function() require('fzf-lua').command_history() end, { desc = "Command History" })
vim.keymap.set({ 'n' }, "<leader>f/", function() require('fzf-lua').search_history() end, { desc = "Search History" })
vim.keymap.set({ 'n' }, "<leader>ft", function() require('fzf-lua').lsp_typedefs() end,
	{ desc = "Goto Type Definition(s)" })
vim.keymap.set({ 'n' }, "<leader>fd", function() require('fzf-lua').lsp_definitions() end,
	{ desc = "Goto Definition(s)" })
vim.keymap.set({ 'n' }, "<leader>fi", function() require('fzf-lua').lsp_implementations() end,
	{ desc = "Goto Implementation(s)" })
vim.keymap.set({ 'n' }, '<leader>f"', function() require('fzf-lua').registers() end, { desc = "Registers" })
vim.keymap.set({ 'n' }, "<leader>f'", function() require('fzf-lua').marks() end, { desc = "Marks" })
vim.keymap.set({ 'n' }, "<leader>fG", function() require('fzf-lua').git_branches() end, { desc = "Git Branches" })
vim.keymap.set({ 'n' }, "<leader>fc", function() require('fzf-lua').git_bcommits() end, { desc = "Buffer Git Commits" })
vim.keymap.set({ 'n' }, "<leader>fC", function() require('fzf-lua').git_commits() end, { desc = "Git Commits" })
vim.keymap.set({ 'n' }, "<leader>fe", function() require('fzf-lua').git_status() end, { desc = "Git Status" })
vim.keymap.set({ 'n' }, "<leader>fo", function() require('fzf-lua').git_stash() end, { desc = "Git Stash" })
vim.keymap.set({ 'n' }, "<leader>fl", function() require('fzf-lua').colorschemes() end, { desc = "Color Scheme" })
vim.keymap.set({ 'n' }, "<leader>fj", function() require('fzf-lua').jumps() end, { desc = "Vim Jumplist" })
vim.keymap.set({ 'n' }, "<leader>fk", function() require('fzf-lua').keymaps() end, { desc = "Vim Keymaps" })
vim.keymap.set({ 'n' }, "<leader>fu", function() require('fzf-lua').resume() end, { desc = "Resume FzfLua" })

-- Code Companion and copilot
vim.keymap.set({ 'n' }, "<leader>cc", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "Toggle Chat" })
vim.keymap.set({ 'n', 'v' }, "<leader>ca", "<cmd>CodeCompanionActions<CR>", { desc = "Actions" })
vim.keymap.set({ 'n', 'v' }, "<leader>cp", "<cmd>Copilot panel<CR>", { desc = "Copilot Suggestions Panel" })
vim.keymap.set({ 'i' }, '<C-f>', '<Plug>(copilot-next)', { desc = "Next Copilot Suggestion" })


-- Iron Repl
vim.keymap.set({ 'n' }, "<leader>rr", "<cmd>IronRepl<CR>", { desc = "Toggle Repl" })
vim.keymap.set({ 'n' }, "<leader>rz", "<cmd>IronRestart<CR>", { desc = "Restart Repl" })
vim.keymap.set({ 'n' }, "<leader>rq", function()
	require('iron.core').send(nil, string.char(03))
end, { desc = "Interrupt Repl" })
vim.keymap.set({ 'n' }, "<leader>ri", "<cmd>IronFocus<CR>", { desc = "Focus Repl" })
vim.keymap.set({ 'n', 'v' }, "<leader>rF", function()
	require('iron.core').send_file()
end, { desc = "Send File" })
vim.keymap.set({ 'n', 'v' }, "<leader>rl", function()
	require('iron.core').send_line()
end, { desc = "Send Line" })
vim.keymap.set({ 'n', 'v' }, "<leader>rf", function()
	local iron = require('iron.core')
	iron.mark_visual()
	iron.send_mark()
	iron.mark_visual()
end, { desc = "Send Selection" })
vim.keymap.set({ 'n', 'v' }, "<leader>rb", function()
	require('iron.core').send_code_block(true)
end, { desc = "Send Code Block" })


-- Lua utils
vim.keymap.set({ 'n', 'v' }, "<leader>v", require('lua_utils').exec_lua, { desc = "Execute Lua" })

-- Terminal
-- Exit terminal mode with ctrl-w hjkl buffer navigation
vim.keymap.set({ "t" }, "<C-w>h", "<C-\\><C-n><C-w>h", { desc = "Focus left" })
vim.keymap.set({ "t" }, "<C-w>j", "<C-\\><C-n><C-w>j", { desc = "Focus down" })
vim.keymap.set({ "t" }, "<C-w>k", "<C-\\><C-n><C-w>k", { desc = "Focus up" })
vim.keymap.set({ "t" }, "<C-w>l", "<C-\\><C-n><C-w>l", { desc = "Focus right" })
-- Exit terminal mode with escape
vim.keymap.set({ "t" }, "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
-- Close window while in terminal mode
vim.keymap.set({ "t" }, "<C-w>q", "<C-\\><C-n><C-w>q", { desc = "Quit current" })

-- Enter terminal mode immediately
-- not sure if I like it, disabled for now
-- vim.api.nvim_create_autocmd({"BufWinEnter", "WinEnter"}, {
--   pattern = {"term://*"},
--   callback = function()
--     vim.cmd("startinsert")
--   end
-- })

-- Tab setup
vim.keymap.set({ "n" }, "<leader>h", "<cmd>tabprevious<CR>", { desc = "Next Tab" })
vim.keymap.set({ "n" }, "<leader>l", "<cmd>tabnext<CR>", { desc = "Previous Tab" })
vim.keymap.set({ "n" }, "<leader>H", "<cmd>tabfirst<CR>", { desc = "First Tab" })
vim.keymap.set({ "n" }, "<leader>L", "<cmd>tablast<CR>", { desc = "Last Tab" })
vim.keymap.set({ "n" }, "<leader>1", "<cmd>1tabnext<CR>", { desc = "Tab 1" })
vim.keymap.set({ "n" }, "<leader>2", "<cmd>2tabnext<CR>", { desc = "Tab 2" })
vim.keymap.set({ "n" }, "<leader>3", "<cmd>3tabnext<CR>", { desc = "Tab 3" })
vim.keymap.set({ "n" }, "<leader>4", "<cmd>4tabnext<CR>", { desc = "Tab 4" })
vim.keymap.set({ "n" }, "<leader>5", "<cmd>5tabnext<CR>", { desc = "Tab 5" })
vim.keymap.set({ "n" }, "<leader>n", "<cmd>tab split<CR>", { desc = "New Tab" })
vim.keymap.set({ "n" }, "<leader>q", "<cmd>tabc<CR>", { desc = "Close Tab" })

-- Editing actions
vim.keymap.set({ "n" }, "<leader>er", vim.lsp.buf.rename, { desc = "Rename Symbol" })
vim.keymap.set({ "n", "x" }, "<leader>ea", vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set({ "n", "x" }, "<leader>es", function() require('fzf-lua').spell_suggest() end, { desc = "Spell Suggest" })
vim.keymap.set({ "n", "i" }, "<C-Space>", vim.lsp.buf.code_action, { desc = "Code Action" })

-- Misc. LSP
vim.keymap.set({ "n" }, "K", function()
	local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
	local rust_lsp = false
	for _, client in ipairs(clients) do
		if client.name == "rust-analyzer" then
			rust_lsp = true
			break
		end
	end
	if rust_lsp then
		-- using RustLsp hover to get the rust-analyzer hover links
		vim.cmd("RustLsp hover actions")
	else
		vim.lsp.buf.hover()
	end
end, { desc = "Hover Text" })

-- Hop setup
local hop = require('hop')
local directions = require('hop.hint').HintDirection

-- mimic the usual f, F, t, T mappings with hop variants
vim.keymap.set({ "n", "o", "x" }, "f", function() hop.hint_char1({ direction = directions.AFTER_CURSOR }) end,
	{ desc = "Hop 1Char After" })
vim.keymap.set({ "n", "o", "x" }, "F", function() hop.hint_char1({ direction = directions.BEFORE_CURSOR }) end,
	{ desc = "Hop 1Char Before" })
vim.keymap.set({ "n", "o", "x" }, "t",
	function() hop.hint_char1({ direction = directions.AFTER_CURSOR, hint_offset = -1 }) end,
	{ desc = "Hop 1Char After-1" })
vim.keymap.set({ "n", "o", "x" }, "T",
	function() hop.hint_char1({ direction = directions.BEFORE_CURSOR, hint_offset = 1 }) end,
	{ desc = "Hop 1Char Before-1" })

-- Hop leader group
-- global line hop
vim.keymap.set({ "n", "o", "x" }, "<leader>ss", function() hop.hint_lines({ multi_windows = true }) end,
	{ desc = "Hop Lines Global" })
vim.keymap.set({ "n", "o", "x" }, "<leader>sd", require('hop-treesitter').hint_nodes, { desc = "Hop Nodes" })
-- hop vertical
vim.keymap.set({ "n", "o", "x" }, "<leader>sv", function() hop.hint_vertical({ direction = directions.AFTER_CURSOR }) end,
	{ desc = "Hop Vertical After" })
vim.keymap.set({ "n", "o", "x" }, "<leader>sV",
	function() hop.hint_vertical({ direction = directions.BEFORE_CURSOR }) end, { desc = "Hop Vertical Before" })
-- hop to words
vim.keymap.set({ "n", "o", "x" }, "<leader>sw", function() hop.hint_words({ direction = directions.AFTER_CURSOR }) end,
	{ desc = "Hop Word After" })
vim.keymap.set({ "n", "o", "x" }, "<leader>sW", function() hop.hint_words({ direction = directions.BEFORE_CURSOR }) end,
	{ desc = "Hop Word Before" })
