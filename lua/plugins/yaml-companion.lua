return {
    "someone-stole-my-name/yaml-companion.nvim",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope.nvim" },
    },
    ft = { "yaml" },
    config = function(_, opts)
        require("telescope").load_extension("yaml_schema")
        local cfg = require("yaml-companion").setup({
            lspconfig = {
                settings = {
                    yaml = {
                        schemas = {
                            ["http://json.schemastore.org/github-workflow"] = { "/.github/workflows/*" },
                            ["http://json.schemastore.org/github-action"] = { "/.github/action.{yml,yaml}" },
                            ["http://json.schemastore.org/kustomization"] = { "kustomization.{yml,yaml}" },
                            ["http://json.schemastore.org/circleciconfig"] = { "/.circleci/config.yml" },
                        }
                    }
                }
            }
        })
        vim.lsp.config("yamlls", cfg)
        vim.lsp.enable("yamlls")
    end,
}
