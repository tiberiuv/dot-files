local opts = { noremap = true, silent = true }
return {
    {
        "nvim-telescope/telescope.nvim",
        keys = {
            { "<C-f>", "<cmd>lua require('telescope.builtin').live_grep()<CR>", opts },
            { "<C-p>", "<cmd>lua require('telescope.builtin').find_files()<CR>", opts },
            { "fd", "<cmd>lua require('telescope.builtin').diagnostics()<CR>", opts },
            { "<C-r>", "<cmd>lua require('telescope.builtin').command_history()<CR>", mode = { "c" }, opts },
        },
        dependencies = {
            "nvim-telescope/telescope-ui-select.nvim",
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")

            telescope.setup({
                defaults = { mappings = { i = { ["<ESC>"] = actions.close } } },
                extensions = {},
            })

            telescope.load_extension("fzf")
            telescope.load_extension("ui-select")
        end,
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
    },
}
