call plug#begin('~/.config/nvim/plugged')

Plug 'junegunn/fzf', {  'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-repeat'
Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
Plug 'preservim/nerdcommenter'
Plug 'editorconfig/editorconfig-vim'
Plug 'airblade/vim-rooter'

Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }

Plug 'vim-airline/vim-airline'
Plug 'terryma/vim-smooth-scroll'
Plug 'mhinz/vim-signify'
Plug 'zivyangll/git-blame.vim'
Plug 'janko-m/vim-test'
Plug 'Vimjas/vim-python-pep8-indent'
"Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'puremourning/vimspector'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'Raimondi/delimitMate'
Plug 'gruvbox-community/gruvbox'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'voldikss/vim-floaterm'
Plug 'vim-scripts/dbext.vim'
"Plug 'nanotee/sqls.nvim'
"Plug 'lighttiger2505/sqls.vim'

" Languages and syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate'}
Plug 'dense-analysis/ale'
Plug 'chr4/nginx.vim'
Plug 'wavded/vim-stylus'
Plug 'tomlion/vim-solidity'
Plug 'glepnir/lspsaga.nvim', { 'branch': 'main' }

" LSP & Snippets & Completion
Plug 'RishabhRD/popfix', { 'do': 'make'}
Plug 'RishabhRD/nvim-lsputils'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'hrsh7th/vim-vsnip'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Database management and competion
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-completion'
Plug 'kristijanhusak/vim-dadbod-ui'

call plug#end()
