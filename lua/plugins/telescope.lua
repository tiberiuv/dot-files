local map = require("utils").map
local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({ defaults = { mappings = { i = { ["<ESC>"] = actions.close } } } })
telescope.load_extension("fzf")
telescope.load_extension("lsp_handlers")

local opts = { noremap = true, silent = true }

map("n", "<C-f>", "<cmd>lua require('telescope.builtin').live_grep()<CR>", opts)
map("n", "<C-p>", "<cmd>lua require('telescope.builtin').find_files()<CR>", opts)
