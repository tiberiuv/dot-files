local yamlls_settings = {
    yaml = {
        schemas = {
            ["http://json.schemastore.org/github-workflow"] = { "/.github/workflows/*" },
            ["http://json.schemastore.org/github-action"] = { "/.github/action.{yml,yaml}" },
            ["http://json.schemastore.org/kustomization"] = { "kustomization.{yml,yaml}" },
            ["http://json.schemastore.org/circleciconfig"] = { "/.circleci/config.yml" },
            kubernetes = { "*.{yml,yaml}" },
            ["./**/crds"] = { "/*.{yml,yaml}" }
        },
        completion = true,
        validate = true,
        schemaStore = {
            enable = true,
            url = "https://github.com/SchemaStore/schemastore",
        }
    },
}
return { settings = yamlls_settings }
