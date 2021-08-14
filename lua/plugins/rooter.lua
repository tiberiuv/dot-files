local vim = vim

vim.cmd [[
    augroup rooter
        autocmd!
        autocmd BufEnter * :Rooter
    augroup END
]]

vim.g.rooter_patterns = {
    "package.json",
    "Cargo.toml",
    "Pipfile",
    "pyproject.toml",
    "Makefile",
    ".git"
}
vim.g.rooter_silent_chdir = 1
