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
Plug 'Raimondi/delimitMate'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'puremourning/vimspector'
Plug 'gruvbox-community/gruvbox'

" Languages and syntax highlighting
Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'yuezk/vim-js'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins', 'for': 'python'}
Plug 'hail2u/vim-css3-syntax'
Plug 'wavded/vim-stylus'
Plug 'arzg/vim-rust-syntax-ext', {'for': 'rust'}
Plug 'cespare/vim-toml'

Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
call plug#end()

call coc#add_extension(
\ 'coc-tsserver', 'coc-flow', 'coc-yaml',
\ 'coc-css', 'coc-json', 'coc-python',
\ 'coc-rust-analyzer', 'coc-texlab',
\ 'coc-styled-components', 'coc-snippets',
\ )
