local function fn()
    local use = use
    use({ "wbthomason/packer.nvim" })

    use({ "npxbr/gruvbox.nvim", requires = { "rktjmp/lush.nvim" } })

    -- Languages and syntax highlighting
    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = "require('plugins.treesitter')",
    })

    use({ "chr4/nginx.vim", ft = ".conf" })
    use({ "wavded/vim-stylus", ft = { ".styl", "stylus" } })
    use({ "tomlion/vim-solidity", ft = ".sol" })
    use({ "Vimjas/vim-python-pep8-indent", ft = ".py" })
    use({
        "hashivim/vim-terraform",
        ft = { ".hcl", ".tf", ".tfvars", ".terraformrc" },
    })

    use({
        "neovim/nvim-lspconfig",
        config = "require('lsp')()",
    })

    use({
        "hrsh7th/nvim-cmp",
        requires = {
            { "L3MON4D3/LuaSnip" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-path", after = "nvim-cmp" },
            { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
        },
        config = "require('plugins.cmp')",
        event = "InsertEnter",
    })

    use({
        "mfussenegger/nvim-dap",
        keys = "<leader>d",
        config = "require('plugins.dap')",
    })

    use({ "tpope/vim-surround" })
    use({ "tpope/vim-sleuth" })
    use({ "tpope/vim-repeat" })

    use({ "b3nj5m1n/kommentary", keys = { "gc", "gcc" } })

    use({ "ahmedkhalf/project.nvim", config = "require('plugins.project')" })

    use({
        "iamcco/markdown-preview.nvim",
        run = "cd app && yarn install",
    })

    use({ "nvim-lua/plenary.nvim", module = "plenary" })

    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
    use({ "gbrlsnchs/telescope-lsp-handlers.nvim" })

    use({
        "nvim-telescope/telescope.nvim",
        config = "require('plugins.telescope')",
    })

    use({
        "lewis6991/gitsigns.nvim",
        config = "require('plugins.gitsigns')",
        event = "BufRead",
    })

    use({
        "janko-m/vim-test",
        cmd = { "TestNearest", "TestFile", "TestSuite", "TestLatest" },
    })

    use({ "antoinemadec/FixCursorHold.nvim", event = "CursorHold" })

    use({ "nvim-lua/lsp_extensions.nvim", event = "BufEnter" })

    use({
        "akinsho/nvim-toggleterm.lua",
        keys = "<C-t>",
        config = "require('plugins.toggle_term')",
    })

    use({
        "kabouzeid/nvim-lspinstall",
        cmd = { "LspInstall", "LspUninstall" },
        event = "BufEnter",
    })

    use({ "kyazdani42/nvim-web-devicons", module = "nvim-web-devicons" })

    use({
        "hoob3rt/lualine.nvim",
        config = "require('plugins.lualine')",
        event = "VimEnter",
    })

    use({
        "kyazdani42/nvim-tree.lua",
        keys = { "<C-n>" },
        config = "require('plugins.nvim-tree')",
        cmd = { "NvimTreeOpen", "NvimTreeToggle" },
    })

    use({
        "karb94/neoscroll.nvim",
        keys = { "<C-u>", "<C-d>" },
        config = "require('plugins.neoscroll')",
    })

    use({
        "jose-elias-alvarez/null-ls.nvim",
        config = "require('plugins.null-ls')",
    })

    use({ "tami5/lspsaga.nvim" })

    use({
        "folke/zen-mode.nvim",
        config = "require('zen-mode').setup({})",
    })
    use({ "kosayoda/nvim-lightbulb" })
end

return require("packer").startup(fn)
