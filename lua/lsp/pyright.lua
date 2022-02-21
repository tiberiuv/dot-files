local pyright_settings = {
    python = {
        analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
        },
    },
}

return {settings = pyright_settings}
