return {
    "simrat39/rust-tools.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap" },
    ft = { "rust", ".rs" },
    config = function()
        local rt = require("rust-tools")
        rt.setup({
            server = {
                on_attach = require("lsp/callbacks").on_attach,
                settings = {
                    ["rust-analyzer"] = {
                        diagnostics = {
                            enable = true,
                            -- enableExperimental = true,
                            disabled = { "unresolved-proc-macro" },
                        },
                        inlayHints = {
                            enable = true,
                            parameterHints = true,
                            typeHints = true,
                        },
                        checkOnSave = {
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
                            allFeatures = true,
                        },
                        procMacro = { enable = true },
                        experimental = { procAttrMacros = true },
                        lruCapacity = 256,
                    },
                },
            },
        })
    end,
}
