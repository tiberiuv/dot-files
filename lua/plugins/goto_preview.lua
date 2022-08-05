local map = require("utils").map

require('goto-preview').setup {
  focus_on_open = false,
  dismiss_on_move = true,
}

local opts = { noremap = true, silent = true }

-- map("n", "vd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", opts)
-- map("n","vi", "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>", opts)
