return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
        local Rule = require("nvim-autopairs.rule")
        local cond = require("nvim-autopairs.conds")
        local npairs = require("nvim-autopairs")

        npairs.setup({
            fast_wrap = {
                map = "<C-e>",
                chars = { "{", "[", "(", '"', "'" },
                pattern = [=[[%'%"%>%]%)%}%,]]=],
                end_key = "$",
                before_key = "h",
                after_key = "l",
                cursor_pos_before = true,
                keys = "qwertyuiopzxcvbnmasdfghjkl",
                manual_position = true,
                highlight = "Search",
                highlight_grey = "Comment",
            },
        })

        -- add markdown block rule for codecompanion buffer
        npairs.add_rule(Rule("```", "```", { "codecompanion" }):with_pair(cond.not_before_char("`", 3)))
    end,
}
