local lua_ls = {
    Lua = {
        runtime = {
            -- Get the language server to recognize LuaJIT globals like `jit` and `bit`
            version = "LuaJIT",
            -- Setup your lua path
            path = vim.split(package.path, ";"),
        },
        diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { "vim" },
        },
        workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
        },
        telemetry = { enabled = false },
    },
}

return {settings = lua_ls}
