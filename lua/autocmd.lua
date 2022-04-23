---------- File types --------
vim.api.nvim_create_augroup("file_types", { clear = true })

vim.api.nvim_create_autocmd("BufNewFile,BufRead *.tsx", {
    group = "file_types",
    command = "setlocal filetype=typescript.tsx"
})

vim.api.nvim_create_autocmd("BufNewFile,BufRead *.ts", {
    group = "file_types",
    command = "setlocal filetype=typescript"
})

vim.api.nvim_create_autocmd("BufNewFile,BufRead *.ino,*.pde", {
    group = "file_types",
    command = "setlocal filetype=cpp"
})

vim.api.nvim_create_autocmd("BufNewFile,BufRead *.sc", {
    group = "file_types",
    command = "setlocal filetype=scala"
})

vim.api.nvim_create_autocmd("BufNewFile,BufRead *.{yaml,yml}", {
    group = "file_types",
    command = "setlocal filetype=yaml"
})

vim.api.nvim_create_autocmd("FileType yaml", {
    group = "file_types",
    command = "setlocal ts=2 sts=2 sw=2 expandtab"
})

-----------------------------
---------- Last Edit --------
vim.api.nvim_create_augroup("last_edit", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost *", {
    group = "last_edit",
    command = [[if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]]
})
-----------------------------
