local map = require("utils").map

map("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

vim.g.nvim_tree_show_icons = {
    git = 1,
    folders = 1,
    files = 1,
    folders_arrows = 1,
}
vim.g.nvim_tree_add_trailing = 1
vim.g.nvim_tree_respect_buf_cwd = 1

local nvim_tree = vim.api.nvim_create_augroup("nvim_tree", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "* ++nested",
    group = nvim_tree,
    command = [[if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif]],
})


require("nvim-tree").setup({
    update_cwd = true,
    update_focused_file = { enable = true, update_cwd = true },
    actions = {
        open_file = {
            quit_on_open = true
        }
    }
})
