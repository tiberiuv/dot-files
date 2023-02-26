return {
    { "nvim-treesitter/nvim-treesitter-textobjects" },
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        opts = {
            -- Modules and its options go here
            ensure_installed = {
                "ruby",
                "rust",
                "python",
                "json",
                "jsdoc",
                "javascript",
                "typescript",
                "tsx",
                "css",
                "yaml",
                "toml",
                "bash",
                "lua",
                "html",
                "c",
                "cpp",
                "java",
                "go",
                "scala",
                "svelte",
                "hcl",
                "terraform",
                "sql",
            },
            highlight = { enable = true },
            incremental_selection = { enable = true },
            indent = { enable = false },
            refactor = { smart_rename = { enable = true }, navigation = { enable = true } },
            textobjects = { enable = true },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
}
