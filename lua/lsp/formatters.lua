return {
    formatters = {
        prettier = {
            rootPatterns = {
                ".prettierrc.js",
                ".prettierrc.json",
                ".prettierrc.js",
                ".prettierrc.yaml"
            },
            command = "prettierd",
            args = {"%filepath"}
        },
        rustfmt = {command = "rustfmt", args = {"--edition", "2018"}},
        lua_format = {
            command = "lua-format",
            args = {'%filepath', "--chop-down-table"}
        },
        black = {
            command = "black",
            args = {"%filepath"},
            doesWriteToFile = true,
            rootPatterns = {".git", "pyproject.toml", "setup.py"}
        }
    },
    formatFiletypes = {
        javascript = "prettier",
        typescript = "prettier",
        javascriptreact = "prettier",
        typescriptreact = "prettier",
        json = "prettier",
        yaml = "prettier",
        rust = "rustfmt",
        lua = "lua_format",
        python = "black"
    }
}
