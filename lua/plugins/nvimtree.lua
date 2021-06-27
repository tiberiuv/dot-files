local map = require("utils").map
local vim = vim

map("n", "<C-n>", ":NvimTreeToggle<CR>", {noremap = true})
map("n", "<C-r>", ":NvimTreeRefresh<CR>", {noremap = true})

vim.g['nvim_tree_follow'] = 1
vim.g['nvim_tree_quit_on_open'] = 1
vim.g['nvim_tree_show_icons'] = {
   git = 1,
   folders = 1,
   files = 1,
   folders_arrows = 1,
}
