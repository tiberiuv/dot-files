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
            -- Make the server aware of Neovim runtime files. Computed, not
            -- listed: this absorbed lua/.luarc.json, whose library was three
            -- absolute paths -- two under a /Users home that does not exist on
            -- Linux, one a Homebrew Cellar path for a neovim nightly. A
            -- .luarc.json in the workspace overrides these client settings, so
            -- those stale paths won wherever the file was read.
            -- ${3rd} is a lua_ls path variable; it expands server-side.
            library = vim.list_extend(vim.api.nvim_get_runtime_file("", true), {
                "${3rd}/luassert/library",
                "${3rd}/luv/library",
            }),
            checkThirdParty = false,
        },
        telemetry = { enabled = false },
    },
}

return {settings = lua_ls}
