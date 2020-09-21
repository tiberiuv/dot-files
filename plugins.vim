call plug#begin('~/.config/nvim/plugged')

Plug 'junegunn/fzf', {  'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-repeat'
Plug 'preservim/nerdtree'
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
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'puremourning/vimspector'
Plug 'gruvbox-community/gruvbox'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'RishabhRD/popfix'
Plug 'RishabhRD/nvim-lsputils'
Plug 'Raimondi/delimitMate'

" Languages and syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'dense-analysis/ale'
Plug 'chr4/nginx.vim'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'

" LSP & Snippets
Plug 'neovim/nvim-lsp'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/diagnostic-nvim'
Plug 'nvim-lua/lsp-status.nvim'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'


call plug#end()
