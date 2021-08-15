local vim = vim
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
        use {"wbthomason/packer.nvim"}

        use "gruvbox-community/gruvbox"

        -- Languages and syntax highlighting
        use {
            "nvim-treesitter/nvim-treesitter",
            run = ":TSUpdate",
            config = "require('plugins.treesitter')"
        }
        use {"chr4/nginx.vim", ft = {".conf"}}
        use {"wavded/vim-stylus", ft = {".styl"}}
        use {"tomlion/vim-solidity", ft = {".sol"}}
        use {"Vimjas/vim-python-pep8-indent", ft = ".py"}

        -- LSP & Linting & Snippets & Completion
        use {"RishabhRD/popfix", run = "make"}
        use "RishabhRD/nvim-lsputils"
        use "neovim/nvim-lspconfig"
        use {
            "hrsh7th/nvim-compe",
            requires = {
                {"hrsh7th/vim-vsnip", event = "InsertCharPre"},
                {"SirVer/ultisnips", event = "InsertCharPre"},
                {"honza/vim-snippets", event = "InsertCharPre"}
            },
            config = "require('plugins.compe_setup')",
            event = "InsertEnter"
        }
        use {
            "nathunsmitty/nvim-ale-diagnostic",
            config = "require('nvim-ale-diagnostic')"
        }

        use {
            "dense-analysis/ale",
            config = "require('plugins.ale')"
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
            "junegunn/fzf.vim"
        }
        use {
            "ojroques/nvim-lspfuzzy",
            requires = {
                {"junegunn/fzf"},
                {"junegunn/fzf.vim"} -- to enable preview (optional)
            }
        }

        use {
            "tpope/vim-surround",
            keys = {"cs", "cst", "ds", "ys"}
        }
        use "tpope/vim-sleuth"
        use {
            "tpope/vim-repeat",
            keys = {"."}
        }

        use {
            "b3nj5m1n/kommentary",
            keys = {"gc", "gcc"}
        }

        use "editorconfig/editorconfig-vim"

        use {
            "ahmedkhalf/project.nvim",
            config = "require('plugins.project')",
            event = "VimEnter"
        }

        use {"iamcco/markdown-preview.nvim", run = "cd app && yarn install", cmd = "MarkdownPreview"}

        use {
            "terryma/vim-smooth-scroll",
            config = "require('plugins.smooth_scroll')",
            keys = {"<C-u>", "<C-d>"}
        }

        use {
            "lewis6991/gitsigns.nvim",
            requires = {
                "nvim-lua/plenary.nvim"
            },
            config = function()
                require("gitsigns").setup(
                    {
                        -- numhl = true,
                        sign_priority = 10
                    }
                )
            end
        }
        use {
            "janko-m/vim-test",
            cmd = {"TestNearest", "TestFile", "TestSuite", "TestLatest"}
        }
        use {
            "antoinemadec/FixCursorHold.nvim",
            event = "CursorHold"
        }
        use "nvim-lua/lsp_extensions.nvim"
        use {
            "akinsho/nvim-toggleterm.lua",
            keys = "<C-t>",
            config = "require('plugins.toggle_term')"
        }
        use {
            "kabouzeid/nvim-lspinstall",
            cmd = {"LspInstall", "LspUninstall"}
        }

        use {
            "hoob3rt/lualine.nvim",
            requires = {"kyazdani42/nvim-web-devicons"},
            config = "require('plugins.lualine')",
            event = "VimEnter"
        }

        use {
            "kyazdani42/nvim-tree.lua",
            keys = {"<C-n>"},
            config = "require('plugins.nvimtree')",
            cmd = {"NvimTreeOpen", "NvimTreeToggle"}
        }
    end
)
