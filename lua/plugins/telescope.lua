local map = require("utils").map

local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup {
    extensions = {
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case" -- or "ignore_case" or "respect_case"
        }
    },
    defaults = {
        mappings = {
            i = {
                ["<ESC>"] = actions.close
            }
        }
    }
}

map("n", "<C-f>", "<cmd>lua require('telescope.builtin').live_grep()<CR>", {noremap = true, silent = true})
map("n", "<C-p>", "<cmd>lua require('telescope.builtin').find_files()<CR>", {noremap = true, silent = true})

telescope.load_extension("fzf")
telescope.load_extension("lsp_handlers")
