local map = require("utils").map

-- Smooth scroll
map("n", "<c-u>", ":call smooth_scroll#up(&scroll, 5, 2)<CR>", {noremap = true, silent = true})
map("n", "<c-d>", ":call smooth_scroll#down(&scroll, 5, 2)<CR>", {noremap = true, silent = true})
