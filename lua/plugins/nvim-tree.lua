return {
    "kyazdani42/nvim-tree.lua",
    keys = { "<C-n>" },
    cmd = { "NvimTreeOpen", "NvimTreeToggle" },
    opts = {
        update_cwd = true,
        update_focused_file = { enable = true, update_cwd = true },
        actions = {
            open_file = {
                quit_on_open = true,
            },
        },
        renderer = {
            add_trailing = true,
        },
        respect_buf_cwd = true,
    },
    config = function(_, opts)
        local map = require("utils").map

        map("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

        local nvim_tree = vim.api.nvim_create_augroup("nvim_tree", { clear = true })
        vim.api.nvim_create_autocmd("BufEnter", {
            pattern = "* ++nested",
            group = nvim_tree,
            command = [[if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif]],
        })
        require("nvim-tree").setup(opts)
    end,
}
