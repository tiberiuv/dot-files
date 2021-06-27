require "nvim-treesitter.configs".setup {
    -- Modules and its options go here
    ensure_installed = {
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
        "scala"
    },
    highlight = {enable = true},
    incremental_selection = {enable = true},
    indent = {enable = true},
    refactor = {
        smart_rename = {enable = true},
        navigation = {enable = true}
    },
    textobjects = {enable = true}
}

--require('tree-sitter-typescript').typescript
--require('tree-sitter-typescript').tsx
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.typescript.used_by = "javascriptflow"
