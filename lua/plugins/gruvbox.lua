return {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    opts = {
        italic = {
            strings = true,
            operators = true,
            comments = true,
        },
        contrast = "",
        transparent_mode = false,
    },
    config = function(_, opts)
        require("gruvbox").setup(opts)
        vim.cmd([[
            colorscheme gruvbox
            filetype plugin indent on
            if has("termguicolors") " set true colors
                set termguicolors
            endif
        ]])
    end,
}
