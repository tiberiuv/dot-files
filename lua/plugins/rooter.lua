local vim = vim

vim.api.nvim_command("augroup rooter")
vim.api.nvim_command("autocmd!")
vim.api.nvim_command("autocmd BufEnter * :Rooter")
vim.api.nvim_command("augroup END")

vim.g.rooter_patterns = {
    "package.json",
    "Cargo.toml",
    "Pipfile",
    "pyproject.toml",
    "Makefile",
    ".git"
}
vim.g.rooter_silent_chdir = 1
