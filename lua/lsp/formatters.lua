return {
    formatters = {
        prettier = {command = "prettier", args = {"--stdin-filepath", "%filepath"}},
        rustfmt = {command = "rustfmt", args = {"--edition", "2018"}},
        luafmt = {command = "luafmt", args = {"--stdin"}}
    },
    formatFiletypes = {
        javascript = "prettier",
        typescript = "prettier",
        javascriptreact = "prettier",
        typescriptreact = "prettier",
        json = "prettier",
        yaml = "prettier",
        rust = "rustfmt",
        lua = "luafmt"
    }
}
