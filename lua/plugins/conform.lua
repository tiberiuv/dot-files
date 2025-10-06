return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            -- Customize or remove this keymap to your liking
            "<leader>f",
            function()
                require("conform").format({ async = true, lsp_fallback = true })
            end,
            mode = { "n", "v" },
            desc = "Format buffer",
        },
    },
    opts = {
        -- Define your formatters
        formatters_by_ft = {
            lua = { "stylua" },
            python = function(bufnr)
                if require("conform").get_formatter_info("ruff_format", bufnr).available then
                    return { "ruff_format" }
                else
                    return { "isort", "black" }
                end
            end,
            javascript = { "prettierd", "prettier", stop_after_first = true },
            typescript = { "prettierd", "prettier", stop_after_first = true },
            javascriptreact = { "prettierd", "prettier", stop_after_first = true },
            typescriptreact = { "prettierd", "prettier", stop_after_first = true },
            rust = { "rustfmt" },
            markdown = { "markdownlint-cli2" },
            yaml = { "prettierd", "prettier", stop_after_first = true },
            ["_"] = { "trim_whitespace" },
        },
    },
    init = function()
        -- If you want the formatexpr, here is the place to set it
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
}
