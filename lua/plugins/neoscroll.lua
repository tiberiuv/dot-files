return {
    "karb94/neoscroll.nvim",
    keys = {
        { "<C-u>", mode = { "n", "v", "x"} },
        { "<C-d>", mode = { "n", "v", "x"} },
    },
    config = function()
        local neoscroll = require('neoscroll')
        neoscroll.setup({
            pre_hook = function(info)
                if info == "cursorline" then
                    vim.wo.cursorline = false
                end
            end,
            post_hook = function(info)
                if info == "cursorline" then
                    vim.wo.cursorline = true
                end
            end,
            mappings = { "<C-d>", "<C-u>" },
            easing_function = "quadratic",
            hide_cursor = true,
        })

        local keymap = {}
        keymap["<C-u>"] = function() neoscroll.ctrl_u({ duration = 350; easing = 'quadratic' }) end;
        keymap["<C-d>"] = function() neoscroll.ctrl_d({ duration = 350; easing = 'quadratic' }) end;
        local modes = { 'n', 'v', 'x' }

        for key, func in pairs(keymap) do
            vim.keymap.set(modes, key, func)
        end
    end,
}
