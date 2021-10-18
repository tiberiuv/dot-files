local debounce = require("lsp.common")

return {
    linters = {
        eslint = {
            sourceName = "eslint",
            command = "eslint",
            rootPatterns = {".eslintrc.js", "package.json"},
            debounce = debounce,
            args = {"--stdin", "--stdin-filename", "%filepath", "--format", "json"},
            parseJson = {
                errorsRoot = "[0].messages",
                line = "line",
                column = "column",
                endLine = "endLine",
                endColumn = "endColumn",
                message = "${message} [${ruleId}]",
                security = "severity"
            },
            securities = {[2] = "error", [1] = "warning"}
        },
        stylelint = {
            sourceName = "stylelint",
            command = "stylelint",
            args = {"--formatter", "compact", "%filepath"},
            rootPatterns = {".stylelintrc"},
            debounce = debounce,
            formatPattern = {
                [[: line (\d+), col (\d+), (warning|error) - (.+?) \((.+)\)]],
                {
                    line = 1,
                    column = 2,
                    security = 3,
                    message = {4, " [", 5, "]"}
                }
            },
            securities = {
                warning = "warning",
                error = "error"
            }
        },
        flake8 = {
            command = "flake8",
            args = {"--format=%(row)d,%(col)d,%(code).1s,%(code)s: %(text)s", "-"},
            debounce = debounce,
            rootPatterns = {".flake8", "setup.cfg", "tox.ini"},
            offsetLine = 0,
            offsetColumn = 0,
            sourceName = "flake8",
            formatLines = 1,
            formatPattern = {
                "(\\d+),(\\d+),([A-Z]),(.*)(\\r|\\n)*$",
                {
                    line = 1,
                    column = 2,
                    security = 3,
                    message = 4
                }
            },
            securities = {
                W = "warning",
                E = "error",
                F = "error",
                C = "error",
                N = "error"
            }
        }
    },
    linter_filetypes = {
        javascript = {"eslint", "stylelint"},
        typescript = {"eslint", "stylelint"},
        typescriptreact = {"eslint", "stylelint"},
        javascriptreact = {"eslint", "stylelint"},
        python = {"flake8"}
    }
}
