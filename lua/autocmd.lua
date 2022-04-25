local last_edit = vim.api.nvim_create_augroup("last_edit", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    group = last_edit,
    command = [[if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]],
})
