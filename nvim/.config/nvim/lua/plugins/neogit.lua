return {
    "NeogitOrg/neogit",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
        "ibhagwan/fzf-lua",
    },
    keys = {
        { "<leader>gg", "<cmd>Neogit kind=floating<CR>", mode = "n", desc = "Neogit" },
    },
    config = function()
        require("neogit").setup({
            -- disable ctrl-c mappings
            mappings = {
                commit_editor = {
                    ["<c-c><c-c>"] = false,
                    ["<c-c><c-k>"] = false,
                },
                commit_editor_I = {
                    ["<c-c><c-c>"] = false,
                    ["<c-c><c-k>"] = false,
                },
                rebase_editor = {
                    ["<c-c><c-c>"] = false,
                    ["<c-c><c-k>"] = false,
                },
                rebase_editor_I = {
                    ["<c-c><c-c>"] = false,
                    ["<c-c><c-k>"] = false,
                },
            },
        })
    end,
}
