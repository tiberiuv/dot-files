return {
    "someone-stole-my-name/yaml-companion.nvim",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope.nvim" },
    },
    ft = { "yaml" },
    config = function(_, opts)
        require("telescope").load_extension("yaml_schema")
        local cfg = require("yaml-companion").setup(opts)
        require("lspconfig")["yamlls"].setup(cfg)
        require("telescope").load_extension("yaml_schema")
    end,
}
