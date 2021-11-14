local map = require"utils".map

map("n", "<up>", "<nop>")
map("n", "<down>", "<nop>")
map("n", "<left>", "<nop>")
map("n", "<right>", "<nop>")

map("i", "<up>", "<nop>")
map("i", "<down>", "<nop>")
map("i", "<left>", "<nop>")
map("i", "<right>", "<nop>")

map("n", "<S-Enter>", "O<Esc>")
map("n", "<CR>", "o<Esc>")

map("n", "<leader>s", "<cmd>lua require'gitsigns'.blame_line(true)<CR>",
    {noremap = true})

-- Remove Highlight on esc
map("n", "<ESC>", ":noh<CR>", {silent = true})

vim.cmd [[
   fun! SetupCommandAlias(from, to)
        exec 'cnoreabbrev <expr> '.a:from .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")' .'? ("'.a:to.'") : ("'.a:from.'"))'
    endfun

    call SetupCommandAlias("W", "w")
    call SetupCommandAlias("Q", "q")
    call SetupCommandAlias("q:", "q")
    call SetupCommandAlias("Wq", "wq")
    call SetupCommandAlias("WQ", "wq")
]]
