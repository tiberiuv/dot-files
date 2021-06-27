local vim = vim
vim.o.background = "dark"
vim.g.gruvbox_contrast_dark = "medium"
vim.g.gruvbox_italic = 1
vim.g.gruvbox_italicize_strings = 1
vim.g.diagnostic_enable_virtual_text = 1

--vim.cmd"colorscheme gruvbox"
--vim.cmd"syntax enable"
--vim.cmd"filetype plugin indent on"
vim.cmd[[
    colorscheme gruvbox
    syntax enable
    filetype plugin indent on
    let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
    if has("termguicolors")     " set true colors
        set t_8f=\[[38;2;%lu;%lu;%lum
        set t_8b=\[[48;2;%lu;%lu;%lum
        set termguicolors
    endif
]]
