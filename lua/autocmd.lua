vim.api.nvim_command("augroup file_types")
vim.api.nvim_command("autocmd!")
vim.api.nvim_command("autocmd BufNewFile,BufRead *.tsx setlocal filetype=typescript.tsx")
vim.api.nvim_command("autocmd BufNewFile,BufRead *.ts setlocal filetype=typescript")
vim.api.nvim_command("autocmd BufNewFile,BufRead *.ino,*.pde set filetype=cpp")
vim.api.nvim_command("autocmd BufNewFile,BufRead *.sc setlocal filetype=scala")
vim.api.nvim_command("autocmd BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml")
vim.api.nvim_command("autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab")
--vim.api.nvim_command("autocmd FileType rust,python,javascript,typescript,yaml,yml,json autocmd BufWritePre <buffer> %s/\s\+$//e")
vim.api.nvim_command("augroup END")
