local sumneko_lua_settings = {
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
        },
        telemetry = { enabled = false },
    },
}

return sumneko_lua_settings
