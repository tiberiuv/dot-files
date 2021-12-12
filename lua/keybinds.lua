local map = require("utils").map

map({ "n", "i" }, "<up>", "<nop>")
map({ "n", "i" }, "<down>", "<nop>")
map({ "n", "i" }, "<left>", "<nop>")
map({ "n", "i" }, "<right>", "<nop>")

map("n", "<S-Enter>", "O<Esc>")
map("n", "<CR>", "o<Esc>")

-- Remove Highlight on esc
map("n", "<ESC>", ":noh<CR>", { silent = true })

vim.cmd([[
   fun! SetupCommandAlias(from, to)
        exec 'cnoreabbrev <expr> '.a:from .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")' .'? ("'.a:to.'") : ("'.a:from.'"))'
    endfun

    call SetupCommandAlias("W", "w")
    call SetupCommandAlias("Q", "q")
    call SetupCommandAlias("q:", "q")
    call SetupCommandAlias("Wq", "wq")
    call SetupCommandAlias("WQ", "wq")
]])
