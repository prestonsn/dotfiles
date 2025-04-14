return {
	"ravitemer/mcphub.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
	},
	-- comment the following line to ensure hub will be ready at the earliest
	cmd = "MCPHub",       -- lazy load by default
	build = "bundled_build.lua", -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
	config = function()
		require("mcphub").setup({
			use_bundled_binary = true, -- Use local binary
			extensions = {
				codecompanion = {
					show_result_in_chat = true, -- Show MCP tool results in the chat buffer
					make_vars = true, -- Create chat #variables from MCP server resources
					requires_approval = true, -- Require approval for tool calls
				}
			}
		})
	end,
}
