local map = require("utils").map
local vim = vim

vim.g.ale_lint_delay = 200
vim.g.ale_lint_on_enter = 0
vim.g.ale_linters_explicit = 1
vim.g.ale_lint_on_save = 1
vim.g.ale_fix_on_save = 0
vim.g.ale_sign_error = "✘"
vim.g.ale_sign_warning = "⚠"

vim.g.ale_python_flake8_args = "--max-line-length=100"
vim.g.ale_rust_rustfmt_options = "--edition 2018"

vim.g.ale_sign_priority = 100
vim.g.ale_lint_on_text_changed = 1
vim.g.ale_sign_column_always = 1
vim.g.ale_python_auto_pipenv = 1
vim.g.ale_disable_lsp = 1
vim.g.ale_completion_enabled = 0

vim.g.ale_virtualenv_dir_names = {"pynvim"}
vim.g.ale_linter_aliases = {
    jsx = {"css", "javascript"},
    tsx = {"css", "typescript"}
}

vim.g.ale_linters = {
    markdown = {"mdl", "writegood"},
    python = {"flake8"},
    javascript = {"eslint"},
    typescript = {"eslint"},
    javascriptreact = {"stylelint", "eslint"},
    typescriptreact = {"stylelint", "eslint"},
    jsx = {"stylelint", "eslint"},
    tsx = {"stylelint", "eslint"},
    lua = {"luacheck"}
}

vim.g.ale_fixers = {
    ["*"] = {"remove_trailing_lines", "trim_whitespace"},
    json = {"prettier"},
    yaml = {"prettier"},
    javascript = {"prettier"},
    typescript = {"prettier"},
    javascriptreact = {"prettier"},
    typescriptreact = {"prettier"},
    rust = {"rustfmt"},
    lua = {"luafmt"}
}

--Next/previous diagnostics
map("n", "[g", ":ALENext<cr>", {silent = true})
map("n", "]g", ":ALENext<cr>", {silent = true})

--Run ale_fixers and save

map("n", "<leader>f", ":<C-u>ALEFix<CR> :w<CR>", {noremap = true, silent = true})
map("n", "Zz", "<c-w>_ <c-w>", {noremap = true, silent = true})
map("n", "Zo", "<c-w>=", {noremap = true, silent = true})
