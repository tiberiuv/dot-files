local last_edit = vim.api.nvim_create_augroup("last_edit", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    group = last_edit,
    command = [[if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]],
})

local file_types = vim.api.nvim_create_augroup("file_types", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*/playbooks/*.yml" },
    group = file_types,
    command = [[set filetype=yaml.ansible]]
})
