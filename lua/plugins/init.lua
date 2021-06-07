local vim = vim
local execute = vim.api.nvim_command
local fn = vim.fn
-- ensure that packer is installed
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
end

vim.cmd 'autocmd BufWritePost plugins/init.lua PackerCompile' -- Auto compile when there are changes in plugins.lua

local packer = require'packer'
local util = require'packer.util'

packer.init({
  package_root = util.join_paths(vim.fn.stdpath('data'), 'site', 'pack')
})

return require('packer').startup(function()
    local use = use
    use { 'wbthomason/packer.nvim' }

    use 'gruvbox-community/gruvbox'

    -- Languages and syntax highlighting
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use 'chr4/nginx.vim'
    use 'wavded/vim-stylus'
    use 'tomlion/vim-solidity'

  -- LSP & Linting & Snippets & Completion
    use { 'RishabhRD/popfix', run = 'make' }
    use 'RishabhRD/nvim-lsputils'
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/nvim-compe'
    use 'hrsh7th/vim-vsnip'
    use 'SirVer/ultisnips'
    use 'honza/vim-snippets'
    use 'nathunsmitty/nvim-ale-diagnostic'
    use { 'glepnir/lspsaga.nvim', branch = 'main' }
    use 'dense-analysis/ale'
    
    use { 'junegunn/fzf', run = "./install -all && mv . ~/.fzf" }
    use 'junegunn/fzf.vim'
    use 'tpope/vim-surround'
    use 'tpope/vim-sleuth'
    use 'tpope/vim-repeat'
    use 'preservim/nerdtree'
    use 'tiagofumo/vim-nerdtree-syntax-highlight'
    use 'ryanoasis/vim-devicons'
    use 'preservim/nerdcommenter'
    use 'editorconfig/editorconfig-vim'
    use 'airblade/vim-rooter'

    use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview'}

    use 'vim-airline/vim-airline'
    use 'terryma/vim-smooth-scroll'
    use 'mhinz/vim-signify'
    use 'zivyangll/git-blame.vim'
    use 'janko-m/vim-test'
    use 'Vimjas/vim-python-pep8-indent'
    --use 'tmux-useins/vim-tmux-focus-events'
    use 'puremourning/vimspector'
    use 'antoinemadec/FixCursorHold.nvim'
    use 'Raimondi/delimitMate'
    use 'nvim-lua/lsp_extensions.nvim'
    use 'voldikss/vim-floaterm'
    use 'vim-scripts/dbext.vim'
    --use 'nanotee/sqls.nvim'
    --use 'lighttiger2505/sqls.vim'

    -- Database management and competion
    use 'tpope/vim-dadbod'
    use 'kristijanhusak/vim-dadbod-completion'
    use 'kristijanhusak/vim-dadbod-ui'

end)
