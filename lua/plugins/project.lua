require("project_nvim").setup {
    patterns = {
        "package.json",
        "Cargo.toml",
        "Pipfile",
        "pyproject.toml",
        "Makefile",
        ".git"
    },
    detection_methods = {"lsp", "pattern"},
    silent_chdir = true
}
