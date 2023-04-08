local rust_analyzer_settings = {
    ["rust-analyzer"] = {
        diagnostics = {
            enable = true,
            -- enableExperimental = true,
            disabled = { "unresolved-proc-macro" },
        },
        inlayHints = {
            enable = true,
            parameterHints = true,
            typeHints = true,
        },
        checkOnSave = {
            command = "clippy",
            extraArgs = { "--tests" },
            allTargets = false,
        },
        assist = {
            importGranularity = "module",
            importPrefix = "by_self",
        },
        cargo = {
            loadOutDirsFromCheck = true,
            target = os.getenv("RUST_ANALYZER_TARGET"),
            allFeatures = true,
        },
        procMacro = { enable = true },
        experimental = { procAttrMacros = true },
        lruCapacity = 256,
    },
}

return { settings = rust_analyzer_settings }
