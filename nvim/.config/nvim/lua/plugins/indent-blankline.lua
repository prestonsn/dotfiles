-- Whitespace and indentation guides.
return {
	'lukas-reineke/indent-blankline.nvim',
	main = 'ibl',
	event = 'VeryLazy',
	opts = function()
		local highlight = {
			"RainbowRed",
			"RainbowYellow",
			"RainbowBlue",
			"RainbowOrange",
			"RainbowGreen",
			"RainbowViolet",
			"RainbowCyan",
		}

		local hooks = require('ibl.hooks')
		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			vim.api.nvim_set_hl(0, 'RainbowRed', { link = 'RainbowDelimiterRed' })
			vim.api.nvim_set_hl(0, 'RainbowYellow', { link = 'RainbowDelimiterYellow' })
			vim.api.nvim_set_hl(0, 'RainbowBlue', { link = 'RainbowDelimiterBlue' })
			vim.api.nvim_set_hl(0, 'RainbowOrange', { link = 'RainbowDelimiterOrange' })
			vim.api.nvim_set_hl(0, 'RainbowGreen', { link = 'RainbowDelimiterGreen' })
			vim.api.nvim_set_hl(0, 'RainbowViolet', { link = 'RainbowDelimiterViolet' })
			vim.api.nvim_set_hl(0, 'RainbowCyan', { link = 'RainbowDelimiterCyan' })
		end)

		return {
			debounce = 50,
			indent = {
				char = require('icons').misc.vertical_bar,
				highlight = highlight,
			},
			scope = {
				show_start = false,
				show_end = false,
			},
		}
	end,
}
