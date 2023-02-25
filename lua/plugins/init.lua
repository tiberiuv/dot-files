return {
    { "tpope/vim-surround", keys = { "cs", "ds", "yss" } },
    { "tpope/vim-sleuth", event = "BufEnter" },
    { "tpope/vim-repeat" },
    { "arkav/lualine-lsp-progress" },
    { "chr4/nginx.vim" },
    { "nfnty/vim-nftables", ft = "nftables" },
    { "wavded/vim-stylus", ft = { "stylus" } },
    { "tomlion/vim-solidity", ft = "solidity" },
    { "Vimjas/vim-python-pep8-indent", ft = "python" },
    { "hashivim/vim-terraform", ft = { "hcl", "terraform" } },
    {
        "b3nj5m1n/kommentary",
        keys = { { "gc", mode = { "n", "v" } }, { "gcc", mode = { "n", "v" } } },
    },
    {
        "iamcco/markdown-preview.nvim",
        ft = { "markdown", "pandoc.markdown", "rmd" },
        build = "cd app && yarn install",
    },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "janko-m/vim-test", cmd = { "TestNearest", "TestFile", "TestSuite", "TestLatest" } },
    { "antoinemadec/FixCursorHold.nvim", event = "CursorHold" },
    { "nvim-treesitter/nvim-treesitter-textobjects" },
    --{"rcarriga/nvim-dap-ui", config = "require('dapui').setup()" },
    {
        "neovim/nvim-lspconfig",
        config = function()
            require("lsp")()
        end,
    },
    {
        "kabouzeid/nvim-lspinstall",
        cmd = { "LspInstall", "LspUninstall" },
        event = "BufEnter",
    },
}
