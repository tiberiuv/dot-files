local map = require "utils".map

map("n", "<up>", "<nop>")
map("n", "<down>", "<nop>")
map("n", "<left>", "<nop>")
map("n", "<right>", "<nop>")

map("i", "<up>", "<nop>")
map("i", "<down>", "<nop>")
map("i", "<left>", "<nop>")
map("i", "<right>", "<nop>")

map("n", "<Leader>s", ":<C-u>call gitblame#echo()<CR>", {noremap = true})

-- Remove Highlight on esc
map("n", "<ESC>", ":noh<CR>", {silent = true})

vim.cmd[[
   fun! SetupCommandAlias(from, to)
        exec 'cnoreabbrev <expr> '.a:from .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")' .'? ("'.a:to.'") : ("'.a:from.'"))'
    endfun

    call SetupCommandAlias("W", "w")
    call SetupCommandAlias("Q", "q")
    call SetupCommandAlias("q:", "q")
    call SetupCommandAlias("Wq", "wq")
    call SetupCommandAlias("WQ", "wq")
]]

vim.cmd[[
    augroup last_edit
      autocmd!
      autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    augroup END
]]
