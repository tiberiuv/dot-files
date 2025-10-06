return {
    on_attach = function(client, bufnr)
        vim.keymap.set(
            "n",
            "<leader>a",
            function()
                vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
                -- or vim.lsp.buf.codeAction() if you don't want grouping.
            end,
            { silent = true, buffer = bufnr }
        )
        vim.keymap.set(
            "n",
            "K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
            function()
                vim.cmd.RustLsp({ 'hover', 'actions' })
            end,
            { silent = true, buffer = bufnr }
        )
        require("lsp/callbacks").on_attach(client, bufnr)
    end,
    settings = {
        ["rust-analyzer"] = {
            diagnostics = {
                enable = true,
                -- enableExperimental = true,
                disabled = { "unresolved-proc-macro" },
            },
            inlayHints = {
                enable = true,
                parameterHints = {
                    enable = true
                },
                typeHints = {
                    enable = true
                },
                chainingHints = {
                    enable = true
                },
                closingBraceHints = {
                    enable = true
                }
            },
            checkOnSave = true,
            check = {
                command = "clippy",
                extraArgs = { "--tests" },
                allTargets = false,
            },
            assist = {
                importGranularity = "module",
                importPrefix = "by_self",
            },
            cargo = {
                loadOutDirsFromCheck = true,
                target = os.getenv("RUST_ANALYZER_TARGET"),
                features = "all",
            },
            procMacro = { enable = true, attributes = { enable = true } },
            lruCapacity = 256,
        },
    }
}
