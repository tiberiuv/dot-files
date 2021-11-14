local null_ls = require("null-ls")
local on_attach = require("lsp.callbacks").on_attach

null_ls.config({
    sources = {
        -- linters
        null_ls.builtins.formatting.eslint_d,
        null_ls.builtins.diagnostics.luacheck, -- formatters
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.formatting.rustfmt,
        null_ls.builtins.formatting.lua_format
    }
})

require("lspconfig")["null-ls"].setup({
    -- see the nvim-lspconfig documentation for available configuration options
    on_attach = on_attach
})
