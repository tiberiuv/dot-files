vim.g.nvim_tree_respect_buf_cwd = 1

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

require("telescope").load_extension("projects")
