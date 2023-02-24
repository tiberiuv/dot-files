return {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
        local null_ls = require("null-ls")
        local formatting = null_ls.builtins.formatting
        local diagnostics = null_ls.builtins.diagnostics

        local sources = {
            -- lua
            formatting.stylua,
            -- python
            formatting.black,
            formatting.isort,
            diagnostics.flake8,
            -- javascript & others
            diagnostics.eslint_d,
            formatting.prettierd.with({
                filetypes = {
                    "javascript",
                    "javascriptreact",
                    "typescript",
                    "typescriptreact",
                    "vue",
                    "css",
                    "scss",
                    "less",
                    "html",
                    "json",
                    "yaml",
                    "markdown",
                    "graphql",
                    "toml",
                },
            }),
            -- rust
            formatting.rustfmt.with({
                extra_args = { "--edition", "2021" },
            }),
            -- yaml
            diagnostics.yamllint.with({
                extra_args = { "-d {extends: default, rules: {document-start: disable}}" },
            }),

            -- shells
            diagnostics.shellcheck.with({
                filetypes = {
                    "sh",
                    "bash",
                },
            }),
        }

        null_ls.setup({
            sources = sources,
        })
    end,
}
