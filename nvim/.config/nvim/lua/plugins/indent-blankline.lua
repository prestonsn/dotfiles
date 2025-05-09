-- Whitespace and indentation guides.
return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "VeryLazy",
    opts = {
        debounce = 50,
        indent = {
            char = require("icons").misc.vertical_bar,
        },
        scope = {
            show_start = false,
            show_end = false,
        },
    },
}
