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
