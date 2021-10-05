local execute = vim.api.nvim_command
local fn = vim.fn

-- ensure that packer is installed
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({"git", "clone", "https://github.com/wbthomason/packer.nvim", install_path})
    execute "packadd packer.nvim"
end

vim.cmd "autocmd BufWritePost plugins/packer.lua PackerCompile" -- Auto compile when there are changes in plugins.lua

local packer = require "packer"
local util = require "packer.util"

packer.init(
    {
        package_root = util.join_paths(vim.fn.stdpath("data"), "site", "pack")
    }
)

return require("packer").startup(
    function()
        local use = use
        use {
            "wbthomason/packer.nvim"
        }

        use {
            "npxbr/gruvbox.nvim",
            requires = {"rktjmp/lush.nvim"}
        }

        -- Languages and syntax highlighting
        use {
            "nvim-treesitter/nvim-treesitter",
            run = ":TSUpdate",
            config = "require('plugins.treesitter')",
            event = "BufEnter"
        }

        use {"chr4/nginx.vim", ft = {".conf"}}
        use {"wavded/vim-stylus", ft = {".styl"}}
        use {"tomlion/vim-solidity", ft = {".sol"}}
        use {"Vimjas/vim-python-pep8-indent", ft = ".py"}

        use "neovim/nvim-lspconfig"

        use {
            "hrsh7th/nvim-cmp",
            requires = {
                {"L3MON4D3/LuaSnip"}
            },
            config = "require('plugins.cmp_config')",
            event = "InsertEnter"
        }

        use {"hrsh7th/cmp-nvim-lsp"}
        use {"hrsh7th/cmp-path", after = "nvim-cmp"}
        use {"saadparwaiz1/cmp_luasnip", after = "nvim-cmp"}

        use {
            "mfussenegger/nvim-dap",
            keys = "<Leader>d"
        }

        -- Project Search
        use {
            "junegunn/fzf",
            run = "./install && mv ./ ~/.fzf",
            keys = {"<C-f>", "<C-p>"},
            config = "require('plugins.fzf')",
            cmd = {
                "FzfFiles",
                "FzfGFiles",
                "FzfBuffers",
                "FzfHelptags",
                "FzfBLines",
                "FzfRg",
                "FzfRG"
            }
        }

        use {
            "junegunn/fzf.vim",
            after = "fzf"
        }

        use {"tpope/vim-surround"}
        use {"tpope/vim-sleuth"}
        use {"tpope/vim-repeat"}

        use {
            "b3nj5m1n/kommentary",
            keys = {"gc", "gcc"}
        }

        use {
            "ahmedkhalf/project.nvim",
            config = "require('plugins.project')",
            event = "VimEnter"
        }

        use {
            "iamcco/markdown-preview.nvim",
            run = "cd app && yarn install",
            cmd = "MarkdownPreview"
        }

        use {
            "nvim-lua/plenary.nvim",
            module = "plenary"
        }

        use {
            "lewis6991/gitsigns.nvim",
            config = "require('plugins.gitsigns')",
            event = "BufRead"
        }

        use {
            "janko-m/vim-test",
            cmd = {"TestNearest", "TestFile", "TestSuite", "TestLatest"}
        }

        use {
            "antoinemadec/FixCursorHold.nvim",
            event = "CursorHold"
        }

        use {
            "nvim-lua/lsp_extensions.nvim",
            event = "BufEnter"
        }

        use {
            "akinsho/nvim-toggleterm.lua",
            keys = "<C-t>",
            config = "require('plugins.toggle_term')"
        }

        use {
            "kabouzeid/nvim-lspinstall",
            cmd = {"LspInstall", "LspUninstall"},
            event = "BufEnter"
        }

        use {
            "kyazdani42/nvim-web-devicons",
            module = "nvim-web-devicons"
        }

        use {
            "hoob3rt/lualine.nvim",
            config = "require('plugins.lualine')",
            event = "VimEnter"
        }

        use {
            "kyazdani42/nvim-tree.lua",
            keys = {"<C-n>"},
            config = "require('plugins.nvimtree')",
            cmd = {"NvimTreeOpen", "NvimTreeToggle"}
        }

        use {
            "karb94/neoscroll.nvim",
            keys = {"<C-u>", "<C-d>"},
            config = "require('plugins.neoscroll')"
        }
    end
)
