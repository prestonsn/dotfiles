return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
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
					adapter = "copilot",
					tools = {
						["mcp"] = {
							callback = function()
								return require("mcphub.extensions.codecompanion")
							end,
							description = "Call tools and resources from the MCP Servers",
							opts = {
								-- mcphub configured to require approval so not needed here
								requires_approval = false,
							},
						},
					},
				},
				inline = {
					adapter = "copilot",
				},
			},
			adapters = {
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
				end
			},
		})
	end,
}
