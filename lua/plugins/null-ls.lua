return function()
    local null_ls = require("null-ls")

    null_ls.config({
        -- you must define at least one source for the plugin to work
        sources = {
            -- lua
            null_ls.builtins.formatting.stylua,
            -- python
            null_ls.builtins.formatting.black,
            null_ls.builtins.formatting.isort,
            null_ls.builtins.diagnostics.flake8,
            -- javascript & others
            null_ls.builtins.diagnostics.eslint_d.with({
                prefer_local = "node_modules/.bin",
            }),
            null_ls.builtins.formatting.prettierd.with({
                prefer_local = "node_modules/.bin",
                args = { "%filepath" },
            }),
            -- rust
            null_ls.builtins.formatting.rustfmt,
        },
    })
end
