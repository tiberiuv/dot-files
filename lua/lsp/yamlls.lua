local yamlls_settings = {
    yaml = {
        schemas = {
            ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml",
        },
    },
}
return { settings = yamlls_settings }
