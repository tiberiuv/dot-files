local packages = {
    ["wbthomason/packer.nvim"] = {},
    ["tpope/vim-surround"] = {},
    ["tpope/vim-sleuth"] = {},
    ["tpope/vim-repeat"] = {},
    ["tami5/lspsaga.nvim"] = {},
    ["gbrlsnchs/telescope-lsp-handlers.nvim"] = {},
    ["nfnty/vim-nftables"] = {},
    ["npxbr/gruvbox.nvim"] = { requires = { "rktjmp/lush.nvim" } },
    ["chr4/nginx.vim"] = { ft = ".conf" },
    ["wavded/vim-stylus"] = { ft = { ".styl", "stylus" } },
    ["tomlion/vim-solidity"] = { ft = ".sol" },
    ["Vimjas/vim-python-pep8-indent"] = { ft = ".py" },

    ["hashivim/vim-terraform"] = { ft = { ".hcl", ".tf", ".tfvars", ".terraformrc" } },

    ["neovim/nvim-lspconfig"] = { config = "require('lsp')()" },

    ["mfussenegger/nvim-dap"] = { keys = "<leader>d", config = "require('plugins.dap')" },

    ["b3nj5m1n/kommentary"] = { keys = { "gc", "gcc" } },

    ["ahmedkhalf/project.nvim"] = { config = "require('plugins.project')" },

    ["iamcco/markdown-preview.nvim"] = { run = "cd app && yarn install" },

    ["nvim-lua/plenary.nvim"] = { module = "plenary" },

    ["nvim-telescope/telescope-fzf-native.nvim"] = { run = "make" },
    ["nvim-telescope/telescope.nvim"] = { config = "require('plugins.telescope')" },

    ["lewis6991/gitsigns.nvim"] = { config = "require('plugins.gitsigns')", event = "BufRead" },

    ["janko-m/vim-test"] = { cmd = { "TestNearest", "TestFile", "TestSuite", "TestLatest" } },

    ["antoinemadec/FixCursorHold.nvim"] = { event = "CursorHold" },

    ["nvim-lua/lsp_extensions.nvim"] = { event = "BufEnter" },

    ["akinsho/nvim-toggleterm.lua"] = { keys = "<C-t>", config = "require('plugins.toggle_term')", branch = "main" },

    ["kabouzeid/nvim-lspinstall"] = { cmd = { "LspInstall", "LspUninstall" }, event = "BufEnter" },

    ["kyazdani42/nvim-web-devicons"] = { module = "nvim-web-devicons" },

    ["hoob3rt/lualine.nvim"] = { config = "require('plugins.lualine')", event = "VimEnter" },

    ["jose-elias-alvarez/null-ls.nvim"] = { config = "require('plugins.null-ls')" },

    ["folke/zen-mode.nvim"] = { config = "require('zen-mode').setup({})" },

    ["hrsh7th/nvim-cmp"] = {
        requires = {
            { "L3MON4D3/LuaSnip" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-path", after = "nvim-cmp" },
            { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
        },
        config = "require('plugins.cmp')",
        event = "InsertEnter",
    },

    ["nvim-treesitter/nvim-treesitter"] = {
        run = ":TSUpdate",
        config = "require('plugins.treesitter')",
    },

    ["nvim-treesitter/nvim-treesitter-textobjects"] = {},

    ["kyazdani42/nvim-tree.lua"] = {
        keys = { "<C-n>" },
        config = "require('plugins.nvim-tree')",
        cmd = { "NvimTreeOpen", "NvimTreeToggle" },
    },

    ["karb94/neoscroll.nvim"] = {
        keys = { "<C-u>", "<C-d>" },
        config = "require('plugins.neoscroll')",
    },
}

local function fn()
    for k, v in pairs(packages) do
        use({
            k,
            requires = v.requires,
            run = v.run,
            config = v.config,
            ft = v.ft,
            event = v.event,
            keys = v.keys,
            module = v.module,
            cmd = v.cmd,
        })
    end
end

return require("packer").startup(fn)
