vim.api.nvim_command("augroup nerdtree")
vim.api.nvim_command("autocmd!")
vim.api.nvim_command("autocmd StdinReadPre * let s:std_in=1")
vim.api.nvim_command("augroup END")

vim.g["NERDTreeLimitedSyntax"] = 1
vim.g["NERDTreeHighlightCursorline"] = 0
vim.g["NERDTreeQuitOnOpen"] = 1
vim.g["NERDTreeIgnore"] = {"__pycache__"}
