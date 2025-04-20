return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- or if using mini.icons/mini.nvim
	-- dependencies = { "echasnovski/mini.icons" },
	opts = {
		keymap = {
			builtin = {
				["<C-d>"] = "preview-page-down",
				["<C-u>"] = "preview-page-up",
			},
		},
		grep = {
			rg_opts =
			"--color=never --no-heading --hidden --with-filename --line-number --column --smart-case --trim --max-columns=4096 -g '!.git/' -g '!node_modules/' -e",
		},
	}
}
