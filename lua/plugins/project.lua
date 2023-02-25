return {
    "ahmedkhalf/project.nvim",
    config = function()
        require("project_nvim").setup({
            patterns = {
                "package.json",
                "Cargo.toml",
                "Pipfile",
                "pyproject.toml",
                "Makefile",
                ".git",
            },
            detection_methods = { "lsp", "pattern" },
            silent_chdir = true,
            update_cwd = true,
            update_focused_file = { enable = true, update_cwd = true },
        })
    end,
}
