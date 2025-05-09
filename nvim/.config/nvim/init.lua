-- Remove default kepmaps introduced in neovim 0.11
vim.keymap.del("n", "gra")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "grn")
vim.keymap.del("n", "grr")

require("config.lazy")
require("config.patches")
require("config.keymappings")

local settings = require("config.settings")

-- General settings (using mini.basics as a starting point)
local o = vim.opt

-- File handling
o.updatetime = 750 -- If nothing typed for this many milliseconds then swap file is written to disk (for crash recovery)
o.undofile = true -- Enable persistent undo (see also `:h undodir`)
o.backup = false -- Don't store backup while overwriting the file
o.writebackup = false -- Don't store backup while overwriting the file

-- Misc
o.mouse = "a" -- Enable mouse for all available modes
vim.cmd("filetype plugin indent on") -- Enable all filetype plugins
o.termguicolors = true -- Enable gui colors
o.splitkeep = "screen" -- Reduce scroll during window split
o.shortmess:append("WcC") -- Reduce command line messages

-- Appearance
o.breakindent = true -- Indent wrapped lines to match line start
o.cursorline = true -- Highlight current line
o.linebreak = true -- Wrap long lines at 'breakat' (if 'wrap' is set)
o.number = true -- Show line numbers
o.splitbelow = true -- Horizontal splits will be below
o.splitright = true -- Vertical splits will be to the right

o.ruler = false -- Don't show cursor position in command line
o.showmode = false -- Don't show mode in command line
o.wrap = false -- Display long lines as just one line
vim.lsp.inlay_hint.enable(false) -- Turn off lsp inlay hints by default

o.signcolumn = "yes" -- Always show sign column (otherwise it will shift text)
o.fillchars = "eob: " -- Don't show `~` outside of buffer
o.pumheight = 10 -- Keep popup menus from being too tall (limit to 10 items)

-- Editing
o.ignorecase = true -- Ignore case when searching (use `\C` to force not doing that)
o.incsearch = true -- Show search results while typing
o.infercase = true -- Infer letter cases for a richer built-in keyword completion
o.smartcase = true -- Don't ignore case when searching if pattern has upper case
o.smartindent = true -- Make indenting smart (NOTE: `guess-indent` plugin will auto match existing file for indent settings so this doesn't matter much)

o.completeopt = "menuone,noselect" -- Customize completions
o.virtualedit = "block" -- Allow going past the end of line in visual block mode
o.formatoptions = "qjl1" -- Don't autoformat comments

-- colorscheme
vim.cmd.colorscheme(settings.colorscheme)
o.background = settings.background

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
        if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
            return
        end

        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
            },
            diagnostics = {
                -- Get the language server to recognize additional neovim globals
                globals = { "bufnr", "au_group" },
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    -- Depending on the usage, you might want to add additional paths here.
                    "${3rd}/luv/library",
                    -- "${3rd}/busted/library",
                },
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                -- library = vim.api.nvim_get_runtime_file("", true)
            },
        })
    end,
    settings = {
        Lua = {},
    },
})

-- zig lsp
require("lspconfig").zls.setup({})

-- python lsp
require("lspconfig").pyright.setup({
    settings = {
        python = {
            analysis = {
                -- Ignore all files for analysis to exclusively use Ruff for linting
                ignore = { "*" },
            },
            -- This is the relative path to the python interpreter for the virtualenv
            pythonPath = ".venv/bin/python",
        },
        pyright = {
            diagnosticMode = "workspace",
        },
    },
})
require("lspconfig").ruff.setup({})

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
            ["rust-analyzer"] = {
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
    dap = {},
}

-- Status line setup
require("lualine").setup({
    options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = "|",
        section_separators = "",
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
        },
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        -- path = 2 for absolute file path
        lualine_c = { { "filename", path = 2 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_d = {},
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {},
})
