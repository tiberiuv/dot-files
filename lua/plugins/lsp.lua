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
            lint.linters.commitlint.args = {
                "-x",
                "@commitlint/config-conventional"
            }
            lint.linters_by_ft = {
                python = { "flake8" },
                javascript = { "eslint_d" },
                shell = { "shellcheck" },
                markdown = { "markdownlint-cli2" },
                gitcommit = { "commitlint" },
            }
            vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
                callback = function()
                    require("lint").try_lint()
                end,
            })
            vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
                callback = function()
                    require("lint").try_lint("commitlint")
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
