local yamlls_settings = {
    yaml = {
        schemas = {
            kubernetes = { "*.yaml" },
            ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
            ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
            ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
            ["./**/crds"] = "./*.yaml"
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
