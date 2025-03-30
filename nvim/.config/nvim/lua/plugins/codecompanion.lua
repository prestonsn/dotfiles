return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("codecompanion").setup({
			strategies = {
				chat = {
					adapter = "copilot",
				},
				inline = {
					adapter = "copilot",
				},
			},
			adapters = {
				gemini = function()
					return require("codecompanion.adapters").extend("gemini", {
						env = {
							api_key = "...",
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
