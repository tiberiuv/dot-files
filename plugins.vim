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
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'Raimondi/delimitMate'
Plug 'gruvbox-community/gruvbox'
Plug 'nvim-lua/lsp_extensions.nvim'
"Plug 'Yggdroot/indentLine'

" Languages and syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate'}
Plug 'dense-analysis/ale'
Plug 'chr4/nginx.vim'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
Plug 'wavded/vim-stylus'

" LSP & Snippets & Completion
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
"Plug 'aca/completion-tabnine', { 'do': './install.sh' }
Plug 'RishabhRD/popfix', { 'do': 'make'}
Plug 'RishabhRD/nvim-lsputils'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'hrsh7th/nvim-compe'

call plug#end()
