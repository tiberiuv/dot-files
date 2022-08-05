local null_ls = require("null-ls")

local sources = {
    -- lua
    null_ls.builtins.formatting.stylua,
    -- python
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.isort,
    null_ls.builtins.diagnostics.flake8,
    -- javascript & others
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.formatting.prettierd.with({
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
    null_ls.builtins.formatting.rustfmt.with({
        extra_args = { "--edition", "2021" },
    }),
    -- yaml
    null_ls.builtins.diagnostics.yamllint.with({
        -- extra_args = { "{extends: default, rules: {document-start: disable}}" },
        extra_args = { "-d relaxed" },
    }),
}

null_ls.setup({
    sources = sources,
})
