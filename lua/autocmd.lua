-- autocmd FileType rust,python,javascript,typescript,yaml,yml,json autocmd BufWritePre <buffer> %s/\s\+$//e
vim.cmd [[
    augroup file_types
        autocmd!
        autocmd BufNewFile,BufRead *.tsx setlocal filetype=typescript.tsx
        autocmd BufNewFile,BufRead *.ts setlocal filetype=typescript
        autocmd BufNewFile,BufRead *.ino,*.pde set filetype=cpp
        autocmd BufNewFile,BufRead *.sc setlocal filetype=scala
        autocmd BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml
        autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
    augroup END
]]

vim.cmd [[
    augroup last_edit
      autocmd!
      autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    augroup END
]]
