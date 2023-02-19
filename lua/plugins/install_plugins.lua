local function get_config(name)
    return function()
        require("plugins." .. name)
    end
end

return {
    { "wbthomason/packer.nvim" },
    { "tpope/vim-surround" },
    { "tpope/vim-sleuth" },
    { "tpope/vim-repeat" },
    { "nfnty/vim-nftables" },
    { "arkav/lualine-lsp-progress" },
    { "nvim-telescope/telescope-ui-select.nvim", dependencies = { "nvim-telescope/telescope.nvim" } },
    { "rmagatti/goto-preview", config = get_config("goto_preview") },
    { "npxbr/gruvbox.nvim", dependencies = { "rktjmp/lush.nvim" } },
    { "chr4/nginx.vim", ft = ".conf" },
    { "wavded/vim-stylus", ft = { ".styl", "stylus" } },
    { "tomlion/vim-solidity", ft = ".sol" },
    { "Vimjas/vim-python-pep8-indent", ft = ".py" },
    { "hashivim/vim-terraform", ft = { ".hcl", ".tf", ".tfvars", ".terraformrc" } },
    {
        "neovim/nvim-lspconfig",
        config = function()
            require("lsp")()
        end,
    },
    {
        "mfussenegger/nvim-dap",
        keys = "<leader>d",
        config = get_config("dap"),
    },
    --{"rcarriga/nvim-dap-ui", config = "require('dapui').setup()" },

    { "b3nj5m1n/kommentary", keys = { "gc", "gcc" } },
    {
        "ahmedkhalf/project.nvim",
        config = get_config("project"),
        dependencies = { "nvim-telescope/telescope.nvim" },
    },
    { "iamcco/markdown-preview.nvim", build = "cd app && yarn install" },
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    {
        "nvim-telescope/telescope.nvim",
        config = get_config("telescope"),
        dependencies = { "nvim-telescope/telescope-ui-select.nvim" },
    },
    {
        "lewis6991/gitsigns.nvim",
        config = get_config("gitsigns"),
        event = "BufRead",
    },
    { "janko-m/vim-test", cmd = { "TestNearest", "TestFile", "TestSuite", "TestLatest" } },
    { "antoinemadec/FixCursorHold.nvim", event = "CursorHold" },
    {
        "akinsho/nvim-toggleterm.lua",
        keys = "<C-t>",
        config = get_config("toggle_term"),
        branch = "main",
    },
    {
        "kabouzeid/nvim-lspinstall",
        cmd = { "LspInstall", "LspUninstall" },
        event = "BufEnter",
    },
    { "kyazdani42/nvim-web-devicons" },
    {
        "hoob3rt/lualine.nvim",
        config = get_config("lualine"),
        event = "VimEnter",
    },
    { "jose-elias-alvarez/null-ls.nvim", config = get_config("null-ls") },
    { "folke/zen-mode.nvim", config = true },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            { "L3MON4D3/LuaSnip" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-path" },
            { "saadparwaiz1/cmp_luasnip" },
        },
        config = get_config("cmp"),
        event = "InsertEnter",
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = get_config("treesitter"),
    },
    { "nvim-treesitter/nvim-treesitter-textobjects" },
    {
        "kyazdani42/nvim-tree.lua",
        keys = { "<C-n>" },
        config = get_config("nvim-tree"),
        cmd = { "NvimTreeOpen", "NvimTreeToggle" },
    },
    {
        "karb94/neoscroll.nvim",
        keys = { "<C-u>", "<C-d>" },
        config = get_config("neoscroll"),
    },
}
