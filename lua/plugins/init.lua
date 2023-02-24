return {
    { "tpope/vim-surround" },
    { "tpope/vim-sleuth" },
    { "tpope/vim-repeat" },
    { "nfnty/vim-nftables" },
    { "arkav/lualine-lsp-progress" },
    { "nvim-telescope/telescope-ui-select.nvim", dependencies = { "nvim-telescope/telescope.nvim" } },
    { "chr4/nginx.vim", ft = ".conf" },
    { "wavded/vim-stylus", ft = { ".styl", "stylus" } },
    { "tomlion/vim-solidity", ft = ".sol" },
    { "Vimjas/vim-python-pep8-indent", ft = ".py" },
    { "hashivim/vim-terraform", ft = { ".hcl", ".tf", ".tfvars", ".terraformrc" } },
    { "b3nj5m1n/kommentary", keys = { "gc", "gcc" } },
    { "iamcco/markdown-preview.nvim", build = "cd app && yarn install" },
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "janko-m/vim-test", cmd = { "TestNearest", "TestFile", "TestSuite", "TestLatest" } },
    { "antoinemadec/FixCursorHold.nvim", event = "CursorHold" },
    { "kyazdani42/nvim-web-devicons" },
    { "folke/zen-mode.nvim", config = true },
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
