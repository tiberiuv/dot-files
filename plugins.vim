call plug#begin('~/.config/nvim/plugged')

Plug 'junegunn/fzf', {  'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'editorconfig/editorconfig-vim'
Plug 'airblade/vim-rooter'
Plug 'tpope/vim-sleuth'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'vim-airline/vim-airline'
Plug 'terryma/vim-smooth-scroll'
Plug 'mhinz/vim-signify'
Plug 'zivyangll/git-blame.vim'
Plug 'janko-m/vim-test'
Plug 'wakatime/vim-wakatime'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'Raimondi/delimitMate'
Plug 'gruvbox-community/gruvbox'
Plug 'dracula/vim'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'puremourning/vimspector'

Plug 'ThePrimeagen/vim-be-good', {'do': '.\install.sh'}

" Languages and syntax highlighting
Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'yuezk/vim-js'
"Plug 'pangloss/vim-javascript'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins', 'for': 'python'}
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'sheerun/vim-polyglot'
Plug 'arzg/vim-rust-syntax-ext', {'for': 'rust'}

Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
call plug#end()

call coc#add_extension(
\ 'coc-tsserver', 'coc-flow', 'coc-yaml',
\ 'coc-css', 'coc-json', 'coc-python',
\ 'coc-rust-analyzer', 'coc-highlight',
\ 'coc-texlab', 'coc-styled-components',
\ 'coc-snippets',
\ )
