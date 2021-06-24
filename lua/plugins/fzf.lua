local map = require("utils").map

-- Use ctrl-p/f for search using fzf
map("n", "<C-p>", ":Files<CR>", {noremap = true, silent = true})
map("n", "<C-f>", ":Rg<CR>", {noremap = true, silent = true})

map("n", "<S-Enter>", "O<Esc>")
map("n", "<CR>", "o<Esc>")

--vim.g["fzf_layout"] = { 'window' = { 'width' = 0.9, 'height': 06 } }
