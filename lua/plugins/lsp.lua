return {
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        dependencies = {
            "mfussenegger/nvim-lint",
            "saghen/blink.cmp",
        },
        config = function()
            local lint = require("lint")
            lint.linters_by_ft = {
                python = { "flake8" },
                javascript = { "eslint_d" },
                shell = { "shellcheck" },
            }
            vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                callback = function()
                    require("lint").try_lint()
                end,
            })
            require("lsp")()
        end,
    },
    {
        "kabouzeid/nvim-lspinstall",
        cmd = { "LspInstall", "LspUninstall" },
        event = "BufEnter",
    },
}
