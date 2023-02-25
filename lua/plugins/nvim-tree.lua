return {
    "kyazdani42/nvim-tree.lua",
    keys = { { "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true } } },
    dependencies = {
        { "kyazdani42/nvim-web-devicons" },
    },
    cmd = { "NvimTreeOpen", "NvimTreeToggle" },
    opts = {
        update_cwd = true,
        respect_buf_cwd = true,
        sync_root_with_cwd = true,
        update_focused_file = {
            enable = true,
            update_cwd = true,
        },
        actions = {
            open_file = {
                quit_on_open = true,
            },
        },
        renderer = {
            add_trailing = true,
        },
    },
    config = function(_, opts)
        local nvim_tree = vim.api.nvim_create_augroup("nvim_tree", { clear = true })
        vim.api.nvim_create_autocmd("BufEnter", {
            pattern = "* ++nested",
            group = nvim_tree,
            command = [[if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif]],
        })
        require("nvim-tree").setup(opts)
    end,
}
