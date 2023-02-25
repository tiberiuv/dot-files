return {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    opts = {
        italic = true,
    },
    config = function(_, opts)
        vim.o.background = "dark"

        require("gruvbox").setup(opts)

        vim.cmd([[
            colorscheme gruvbox
            filetype plugin indent on
            let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
            if has("termguicolors")     " set true colors
                set t_8f=\[[38;2;%lu;%lu;%lum
                set t_8b=\[[48;2;%lu;%lu;%lum
                set termguicolors
            endif
        ]])
    end,
}
