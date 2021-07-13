local map = require("utils").map

vim.cmd [[command! -bang -nargs=* Rg call fzf#vim#grep('rg --column --line-number --no-heading --color=always --smart-case --glob "!{node_modules,.git,*.lock,target,flow-typed,dist}" -- '.shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)
]]

-- Use ctrl-p/f for search using fzf
map("n", "<C-p>", ":Files<CR>", {noremap = true, silent = true})
map("n", "<C-f>", ":Rg<CR>", {noremap = true, silent = true})

vim.g["fzf_layout"] = {
    window = {width = 0.9, height = 0.6}
}

require("lspfuzzy").setup {}
