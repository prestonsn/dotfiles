-- Remove default kepmaps introduced in neovim 0.11
vim.keymap.del('n', 'gra')
vim.keymap.del('n', 'gri')
vim.keymap.del('n', 'grn')
vim.keymap.del('n', 'grr')

require('config.lazy')
require('config.patches')
require('config.keymappings')

local settings = require('config.settings')

-- NOTE: `guess-indent` plugin will auto match existing file for indent settings so they are left default
-- smart/auto indent for new lines - seems to give best results but can also be autoindent = true or smartindent = true
vim.opt.cindent = true
-- Keep popup menus from being too tall (limit to 30 items)
vim.opt.pumheight = 30

-- Global settings
-- have a fixed column for the diagnostics to appear in
-- this removes the jitter/shift right when warnings/errors flow in
vim.opt.signcolumn = "yes"
-- show relative line numbers by default
vim.opt.relativenumber = true
-- colorscheme
vim.cmd.colorscheme(settings.colorscheme)
vim.opt.background = settings.background
-- If nothing typed for this many milliseconds then swap file is written to disk (for crash recovery)
vim.opt.updatetime = 750

-- Default to rounded borders for floating windows (only if unset)
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = opts.border or "rounded"
	return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- using mason for lsp setup
require("mason").setup()
-- mason-lspconfig just to simplify setup of lsp
require("mason-lspconfig").setup()
-- go lsp
require("lspconfig").gopls.setup({})
-- lua lsp
require("lspconfig").lua_ls.setup({
	-- setup copied from here: https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/lua_ls.lua
	on_init = function(client)
		-- some setup to eliminate warnings when editing neovim lua files
		-- only override for neovim lua config files if no .luarc.json defined
		local path = client.workspace_folders[1].name
		if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
			return
		end

		client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using
				-- (most likely LuaJIT in the case of Neovim)
				version = 'LuaJIT'
			},
			diagnostics = {
				-- Get the language server to recognize additional neovim globals
				globals = { 'bufnr', 'au_group' },
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					-- Depending on the usage, you might want to add additional paths here.
					"${3rd}/luv/library",
					-- "${3rd}/busted/library",
				}
				-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
				-- library = vim.api.nvim_get_runtime_file("", true)
			}
		})
	end,
	settings = {
		Lua = {}
	}
})

-- zig lsp
require('lspconfig').zls.setup({})

-- python lsp
require('lspconfig').pyright.setup({
	settings = {
		python = {
			analysis = {
				-- Ignore all files for analysis to exclusively use Ruff for linting
				ignore = { '*' },
			},
			-- This is the relative path to the python interpreter for the virtualenv
			pythonPath = ".venv/bin/python"
		},
		pyright = {
			diagnosticMode = "workspace"
		}
	}
})
require('lspconfig').ruff.setup({})

-- rust lsp
vim.g.rustaceanvim = {
	-- Plugin configuration
	tools = {
		-- Don't run clippy on save
		enable_clippy = false,
	},
	-- LSP configuration
	server = {
		on_attach = {},
		capabilities = {},
		load_vscode_settings = false,
		default_settings = {
			-- rust-analyzer language server configuration
			['rust-analyzer'] = {
				rustfmt = {
					-- nightly rust fmt
					extraArgs = { settings.rust_fmt_extra_args },
				},
				-- increase limit to 1024 for searching across workspace (defaults to only 128)
				workspace = { symbol = { search = { limit = 1024 } } },
				cargo = {
					-- enable all feature flags for opened project
					features = "all",
				},
			},
		},
	},
	-- DAP configuration
	dap = {
	},
}

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp", { clear = true }),
	callback = function(args)
		-- lsp format on save
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = args.buf,
			callback = function()
				vim.lsp.buf.format { async = false, id = args.data.client_id }
			end,
		})
	end
})

-- Turn off lsp inlay hints by default
vim.lsp.inlay_hint.enable(false)

-- Status line setup
require('lualine').setup {
	options = {
		icons_enabled = true,
		theme = 'auto',
		component_separators = '|',
		section_separators = '',
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = false,
		refresh = {
			statusline = 500,
			tabline = 500,
			winbar = 500,
		}
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		-- path = 2 for absolute file path
		lualine_c = { { 'filename', path = 2 } },
		lualine_x = { 'encoding', 'fileformat', 'filetype' },
		lualine_y = { 'progress' },
		lualine_z = { 'location' }
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { 'filename' },
		lualine_d = {},
		lualine_x = { 'location' },
		lualine_y = {},
		lualine_z = {}
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {}
}
