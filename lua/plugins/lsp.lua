return {
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            require("lsp")()
        end,
    },
    {
        "kabouzeid/nvim-lspinstall",
        cmd = { "LspInstall", "LspUninstall" },
        event = "BufEnter",
    },
}
