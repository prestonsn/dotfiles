return {
	'nvim-treesitter/nvim-treesitter',
	config = function()
		require("nvim-treesitter.configs").setup {
			highlight = {
				enable = true,
			}, ensure_installed = {
			"bash",
			"c",
			"cpp",
			"go",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"rust",
			"vim",
			"vimdoc",
		}
		}
	end,
}
