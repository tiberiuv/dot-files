return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-telescope/telescope-ui-select.nvim" },
    config = function()
        local map = require("utils").map
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        telescope.setup({
            defaults = { mappings = { i = { ["<ESC>"] = actions.close } } },
            extensions = {},
        })

        telescope.load_extension("fzf")
        telescope.load_extension("ui-select")

        local opts = { noremap = true, silent = true }

        map("n", "<C-f>", "<cmd>lua require('telescope.builtin').live_grep()<CR>", opts)
        map("n", "<C-p>", "<cmd>lua require('telescope.builtin').find_files()<CR>", opts)
        map("n", "fd", "<cmd>lua require('telescope.builtin').diagnostics()<CR>", opts)
        map("c", "<C-r>", "<cmd>lua require('telescope.builtin').command_history()<CR>", opts)
    end,
}
