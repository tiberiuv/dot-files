return {
    "nvimtools/none-ls.nvim",
    lazy = false,
    config = function()
        local null_ls = require("null-ls")
        local formatting = null_ls.builtins.formatting
        local diagnostics = null_ls.builtins.diagnostics

        null_ls.setup({
            sources = {
                formatting.stylua,
                formatting.black,
                formatting.isort,
                formatting.trim_whitespace,
                formatting.rustfmt.with({
                    extra_args = { "--edition", "2021" },
                }),
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
                        "markdown",
                        "graphql",
                        "toml",
                    },
                }),
                formatting.yamlfmt,
                diagnostics.flake8,
                diagnostics.eslint_d,
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
            },
        })
    end,
}
