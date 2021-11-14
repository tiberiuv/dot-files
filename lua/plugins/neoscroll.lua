-- vim.b.neoscroll_performance_mode = true
require("neoscroll").setup({
    pre_hook = function(info)
        if info == "cursorline" then vim.wo.cursorline = false end
    end,
    post_hook = function(info)
        if info == "cursorline" then vim.wo.cursorline = true end
    end,
    mappings = {"<C-d>", "<C-u>"},
    easing_function = "quadratic",
    hide_cursor = true
})

local t = {}
t['<C-u>'] = {
    'scroll',
    {'-vim.wo.scroll', 'true', '350', 'quadratic', [['cursorline']]}
}
t['<C-d>'] = {
    'scroll',
    {'vim.wo.scroll', 'true', '350', 'quadratic', [['cursorline']]}
}
require('neoscroll.config').set_mappings(t)
