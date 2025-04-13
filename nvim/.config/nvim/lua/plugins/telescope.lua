return {
	'nvim-telescope/telescope.nvim',
	dependencies = { 'nvim-lua/plenary.nvim' },
	config = function()
		-- Show line numbers inside telescope previews
		vim.cmd("autocmd User TelescopePreviewerLoaded setlocal number")

		-- Telescope fzf extension for performance on fuzzy searching
		require('telescope').load_extension('fzf')
		local actions = require("telescope.actions")
		local copy_tele_selection = function()
			local entry = require("telescope.actions.state").get_selected_entry()
			-- honor clipboard settings
			local cb_opts = vim.opt.clipboard:get()
			if vim.tbl_contains(cb_opts, "unnamed") then vim.fn.setreg("*", entry.path) end
			if vim.tbl_contains(cb_opts, "unnamedplus") then vim.fn.setreg("+", entry.path) end
			vim.fn.setreg("", entry.path)
		end

		require("telescope").setup {
			defaults = {
				mappings = {
					i = {
						["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
						["<C-y>"] = copy_tele_selection,
						["<C-f>"] = actions.to_fuzzy_refine,
					},
					n = {
						["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
						["<C-y>"] = copy_tele_selection,
						["<C-f>"] = actions.to_fuzzy_refine,
					},
				},
				-- ignore git and node_modules directories since no longer ignoring hidden files
				file_ignore_patterns = { ".git/", "node_modules" },
				-- args for live grep, set here to include hidden files
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--hidden",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--trim",
				},
			},
			pickers = {
				find_files = {
					follow = true
				},
				buffers = {
					mappings = {
						i = {
							["<c-b>"] = actions.delete_buffer + actions.move_to_top,
						},
						n = {
							["<c-b>"] = actions.delete_buffer + actions.move_to_top,
						}
					}
				}
			}
		}
	end
}
