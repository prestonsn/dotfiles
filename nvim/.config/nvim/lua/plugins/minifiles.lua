-- Set focused directory as current working directory
local set_cwd = function()
    local minifiles = require("mini.files")
    local path = (minifiles.get_fs_entry() or {}).path
    if path == nil then
        return vim.notify("Cursor is not on valid entry")
    end
    vim.fn.chdir(vim.fs.dirname(path))
    minifiles.trim_left()
end

local function map_split(buf_id, lhs, direction)
    local minifiles = require("mini.files")

    local function rhs()
        local window = minifiles.get_explorer_state().target_window

        -- Noop if the explorer isn't open or the cursor is on a directory.
        if window == nil or minifiles.get_fs_entry().fs_type == "directory" then
            return
        end

        -- Make a new window and set it as target.
        local new_target_window
        vim.api.nvim_win_call(window, function()
            vim.cmd(direction .. " split")
            new_target_window = vim.api.nvim_get_current_win()
        end)

        minifiles.set_target_window(new_target_window)

        -- Go in and close the explorer.
        minifiles.go_in({ close_on_file = true })
    end

    vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = "Split " .. string.sub(direction, 12) })
end

--- Yank in register path of entry under cursor.
---@param rel_path boolean Yank relative path if true, full path otherwise.
local yank_path = function(rel_path)
    local minifiles = require("mini.files")
    local path = (minifiles.get_fs_entry() or {}).path
    if path == nil then
        return vim.notify("Cursor is not on valid entry")
    end
    if rel_path then
        path = vim.fn.fnamemodify(path, ":.")
    end
    vim.fn.setreg(vim.v.register, path)
end

-- Open path with system default handler (useful for non-text files)
local ui_open = function()
    local minifiles = require("mini.files")
    vim.ui.open(minifiles.get_fs_entry().path)
end

local luv = vim.loop
-- Function to recursively add files in a directory to chat references
local function traverse_directory(path, chat)
    local handle, err = luv.fs_scandir(path)
    if not handle then
        return print("Error scanning directory: " .. err)
    end

    while true do
        local name, type = luv.fs_scandir_next(handle)
        if not name then
            break
        end

        local item_path = path .. "/" .. name
        if type == "file" then
            -- add the file to references
            chat.references:add({
                id = "<file>" .. item_path .. "</file>",
                path = item_path,
                source = "codecompanion.strategies.chat.slash_commands.file",
                opts = {
                    pinned = true,
                },
            })
        elseif type == "directory" then
            -- recursive call for a subdirectory
            traverse_directory(item_path, chat)
        end
    end
end

-- Function to add the current file or directory (all files recursively) to Code Companion
local add_to_code_companion = function()
    local minifiles = require("mini.files")
    local path = minifiles.get_fs_entry().path
    local codecompanion = require("codecompanion")
    local chat = codecompanion.last_chat()
    -- create chat if none exists
    if chat == nil then
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
            id = "<file>" .. path .. "</file>",
            path = path,
            source = "codecompanion.strategies.chat.slash_commands.file",
            opts = {
                pinned = true,
            },
        })
    end
end

return {
    "echasnovski/mini.files",
    lazy = false,
    keys = {
        {
            "<leader>e",
            function()
                local bufname = vim.api.nvim_buf_get_name(0)
                local path = vim.fn.fnamemodify(bufname, ":p")

                -- Open at CWD if the buffer isn't valid.
                if path and vim.uv.fs_stat(path) then
                    require("mini.files").open(bufname, false)
                else
                    require("mini.files").open()
                end
            end,
            desc = "Browse Files",
        },
        {
            "<leader>E",
            function()
                require("mini.files").open()
            end,
            desc = "Browse Files at CWD",
        },
    },
    opts = {
        windows = { width_nofocus = 25 },
    },
    config = function()
        -- HACK: Notify LSPs that a file got renamed.
        -- Borrowed this from snacks.nvim.
        vim.api.nvim_create_autocmd("User", {
            desc = "Notify LSPs that a file was renamed",
            pattern = "MiniFilesActionRename",
            callback = function(args)
                local changes = {
                    files = {
                        {
                            oldUri = vim.uri_from_fname(args.data.from),
                            newUri = vim.uri_from_fname(args.data.to),
                        },
                    },
                }
                local will_rename_method, did_rename_method =
                    vim.lsp.protocol.Methods.workspace_willRenameFiles,
                    vim.lsp.protocol.Methods.workspace_didRenameFiles
                local clients = vim.lsp.get_clients()
                for _, client in ipairs(clients) do
                    if client:supports_method(will_rename_method) then
                        local res = client:request_sync(will_rename_method, changes, 1000, 0)
                        if res and res.result then
                            vim.lsp.util.apply_workspace_edit(res.result, client.offset_encoding)
                        end
                    end
                end

                for _, client in ipairs(clients) do
                    if client:supports_method(did_rename_method) then
                        client:notify(did_rename_method, changes)
                    end
                end
            end,
        })

        vim.api.nvim_create_autocmd("User", {
            pattern = "MiniFilesBufferCreate",
            callback = function(args)
                vim.api.nvim_set_hl(0, "MiniFilesTitleFocused", { link = "Title" })
                local buf_id = args.data.buf_id
                vim.keymap.set("n", "g.", set_cwd, { buffer = buf_id, desc = "Set cwd" })
                vim.keymap.set("n", "gX", ui_open, { buffer = buf_id, desc = "OS open" })
                vim.keymap.set("n", "gy", function()
                    yank_path(true)
                end, { buffer = buf_id, desc = "Yank relative path" })
                vim.keymap.set("n", "gY", function()
                    yank_path(false)
                end, { buffer = buf_id, desc = "Yank full path" })
                vim.keymap.set("n", "gC", add_to_code_companion, { buffer = buf_id, desc = "Add to Code Companion" })
                map_split(buf_id, "<C-w>s", "belowright horizontal")
                map_split(buf_id, "<C-w>v", "belowright vertical")
            end,
        })
    end,
}
