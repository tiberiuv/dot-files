local vim = vim

vim.g.indentLine_char_list = {"┆"}
vim.g.indentLine_setColors = 0
vim.g.indentLine_setConceal = 0
vim.g.indentLine_enabled = 1

vim.api.nvim_command("augroup identline")
vim.api.nvim_command("autocmd!")
vim.api.nvim_command("autocmd BufRead,BufNewFile *.py,*.rb let g:indentLine_setConceal = 2")
vim.api.nvim_command("autocmd BufRead,BufNewFile *.py,*.rb let g:indentLine_enabled = 1")
vim.api.nvim_command("augroup END")
