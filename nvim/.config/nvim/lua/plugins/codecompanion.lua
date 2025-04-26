return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    keys = {
        { "<leader>cc", "<cmd>CodeCompanionChat Toggle<CR>", mode = { "n" }, desc = "Code Companion Chat" },
        { "<leader>ca", "<cmd>CodeCompanionActions<CR>", mode = { "n", "v" }, desc = "Actions" },
    },
    config = function()
        require("codecompanion").setup({
            display = {
                action_palette = {
                    provider = "default",
                },
            },
            strategies = {
                chat = {
                    adapter = "copilot_chat",
                },
                inline = {
                    adapter = "copilot",
                },
            },
            adapters = {
                -- Define the custom adapter instance for chat so we can have different default model
                copilot_chat = function()
                    return require("codecompanion.adapters").extend("copilot", {
                        name = "copilot_chat",
                        schema = {
                            model = {
                                default = "gemini-2.5-pro",
                            },
                        },
                    })
                end,
                copilot = function()
                    return require("codecompanion.adapters").extend("copilot", {
                        schema = {
                            model = {
                                default = "gpt-4.1",
                            },
                        },
                    })
                end,
                gemini = function()
                    return require("codecompanion.adapters").extend("gemini", {
                        env = {
                            api_key = "cmd:cat ~/.config/.gemini-api-key",
                        },
                        schema = {
                            model = {
                                default = "gemini-2.5-pro-exp-03-25",
                            },
                        },
                    })
                end,
            },
        })
    end,
}
