filetype plugin on
filetype indent on
set encoding=UTF-8
set hidden
set autoindent
set nocompatible
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set cmdheight=2
set nowrap
set expandtab
set backspace=indent,eol,start
set number
set nocursorline
set wildmenu
set autochdir
" Display row and column number when last closed file
set laststatus=2
set showmatch
set smarttab
set wrap "Wrap lines
set timeoutlen=500
set ttimeoutlen=50
set updatetime=200
set redrawtime=10000
set autoread
set number relativenumber
set synmaxcol=200
set ttyfast
set lazyredraw
set noshowcmd
set noruler
set completeopt=menuone,noinsert,noselect
" Some servers have issues with backup files
set nobackup
set nowritebackup

" -------------------------------------
" Search
set ignorecase
set smartcase
set incsearch
set hlsearch
" -------------------------------------

set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
set grepformat=%f:%l:%c:%m


" Keep backups in different directory
set backupdir=~/.cache/vim/backup//
set directory=~/.cache/vim/swap//
set undodir=~/.cache/vim/undo//
set undofile

" Don't pass messages to |ins-completion-menu|.
"set shortmess+=c
set signcolumn=yes  " Always show the signcolumn
set colorcolumn=100

let g:cursorhold_updatetime = 100

"let g:rooter_patterns = ['package.json', 'cargo.toml', 'Pipfile', '.git/', '.git']
let g:rooter_patterns = ['package.json', 'cargo.toml', 'Pipfile', '.git/', '.git']
autocmd BufEnter * :Rooter


 "Load plugins
source ~/.config/nvim/plugins.vim
luafile ~/.config/nvim/init.lua
" -------------------------------------

" Return to last edit position when opening files
augroup last_edit
  autocmd!
  autocmd BufReadPost *
       \ if line("'\"") > 0 && line("'\"") <= line("$") |
       \   exe "normal! g`\"" |
       \ endif
augroup END
" -------------------------------------
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
" Use ctrl-p/f for search using fzf
nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <C-f> :Rg<CR>

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case --glob "!{node_modules,.git,*.lock,target,flow-typed,dist}" -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 5, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 5, 2)<CR>

nnoremap q: <nop>
nnoremap Q <nop>

" Key bindings
nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>

fun! SetupCommandAlias(from, to)
    exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfun

call SetupCommandAlias("W", "w")
call SetupCommandAlias("Q", "q")
call SetupCommandAlias("Wq", "wq")
call SetupCommandAlias("WQ", "wq")

" run git blame
nnoremap <Leader>s :<C-u>call gitblame#echo()<CR>
" -------------------------------------
" Nerdtree

let g:NERDTreeIgnore=['__pycache__']
let NERDTreeQuitOnOpen = 1


function! NERDTreeToggleInCurDir()
  " If NERDTree is open in the current buffer
  if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
    exe ":NERDTreeClose"
  else
    if (expand("%:t") != '')
      exe ":NERDTreeFind"
    else
      exe ":NERDTreeToggle"
    endif
  endif
endfunction

map <C-n> :call NERDTreeToggleInCurDir()<CR>

augroup nerdtree
    autocmd!
    autocmd StdinReadPre * let s:std_in=1
augroup END

let g:NERDTreeLimitedSyntax = 1
let g:WebDevIconsOS = 'Darwin'
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
let g:DevIconsEnableFolderExtensionPatternMatching = 1
let g:NERDTreeHighlightCursorline = 0


" -------------------------------------
" ALE
let g:ale_lint_delay = 200
let g:ale_lint_on_enter = 0
let g:ale_linters_explicit = 1
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 0
let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'
"let g:ale_rust_rustfmt_executable="rustfmt"
let g:ale_python_flake8_args="--max-line-length=100"

let g:ale_sign_priority = 100
let g:ale_lint_on_text_changed = 0
let g:ale_sign_column_always = 1
let g:ale_python_auto_pipenv = 1
let g:ale_disable_lsp = 1

let g:ale_virtualenv_dir_names = ['pynvim']
let g:ale_linter_aliases = {
\   'jsx': ['css', 'javascript'],
\   'tsx': ['css', 'typescript'],
\}

let g:ale_linters = {
\   'markdown': ['mdl', 'writegood'],
\   'python': ['flake8', 'pyright'],
\   'javascript': ['eslint'],
\   'typescript': ['eslint'],
\   'jsx': ['stylelint', 'eslint'],
\   'tsx': ['stylelint', 'eslint'],
\   'lua': ['luacheck'],
\}

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'json': ['prettier'],
\   'yaml': ['prettier'],
\   'javascript': ['prettier'],
\   'typescript': ['prettier'],
\   'python': ['black'],
\   'rust': ['rustfmt'],
\   'lua': ['luafmt'],
\}

" Next/previous diagnostics
nmap <silent> [g :ALENext<cr>
nmap <silent> ]g :ALEPrevious<cr>

" run ale_fixers and save
nnoremap <Leader>f :<C-u>ALEFix<CR> \| :w<CR>

autocmd BufNewFile,BufRead *.jsx setlocal filetype=javascript.jsx
autocmd BufNewFile,BufRead *.tsx setlocal filetype=typescript.tsx
autocmd BufNewFile,BufRead *.ts setlocal filetype=typescript
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType yml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType rust,python,javascript,typescript,yaml,yml,json autocmd BufWritePre <buffer> %s/\s\+$//e

let g:vim_jsx_pretty_colorful_config = 1
let g:delimitMate_expand_cr = 1
let g:rainbow_active = 1
let g:airline_powerline_fonts = 1
let g:WebDevIconsOS = 'Darwin'
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#nvimlsp#enabled = 1
let g:python3_host_prog = '~/pynvim/bin/python'
let g:EditorConfig_exclude_patterns = ['fugitive://.*']
let test#python#runner = 'pyunit'

" Remove Highlight on esc
nmap <silent><ESC> :noh<CR>

let $NVIM_TUI_ENABLE_TRUE_COLOR=1
if has("termguicolors")     " set true colors
    set t_8f=\[[38;2;%lu;%lu;%lum
    set t_8b=\[[48;2;%lu;%lu;%lum
    set termguicolors
endif

set background=dark
let g:gruvbox_contrast_dark='medium'
let g:gruvbox_italic=1
let g:gruvbox_italicize_strings=1
silent colorscheme gruvbox


"vimrc
let g:completion_chain_complete_list = {
    \ 'default': [
    \    {'complete_items': ['lsp', 'snippet', 'tabnine' ]},
    \    {'mode': '<c-p>'},
    \    {'mode': '<c-n>'}
    \]
\}

" tabnine priority (default: 0)
" Defaults to lowest priority
let g:completion_tabnine_priority = 0

" tabnine binary path (default: expand("<sfile>:p:h:h") .. "/binaries/TabNine_Linux")
"let g:completion_tabnine_tabnine_path = ""

" max tabnine completion options(default: 7)
let g:completion_tabnine_max_num_results=7

" sort by tabnine score (default: 0)
let g:completion_tabnine_sort_by_details=1

" max line for tabnine input(default: 1000)
" from current line -1000 ~ +1000 lines is passed as input
let g:completion_tabnine_max_lines=1000

" Statusline
"function! LspStatus() abort
  "if luaeval('#vim.lsp.buf_get_clients() > 0')
    "return luaeval("require('lsp-status').status()")
  "endif

  "return ''
"endfunction

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ completion#trigger_completion()

if exists('*complete_info')
  " Use `complete_info` if your (Neo)Vim version supports it.
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" fix conflict between completion-nvim and autopairs
let g:completion_confirm_key = ""
imap <expr> <cr>  pumvisible() ? complete_info()["selected"] != "-1" ?
                 \ "\<Plug>(completion_confirm_completion)"  : "\<c-e>\<CR>" :  "\<CR>"

let g:completion_enable_snippet = 'UltiSnips'

augroup CompletionTriggerCharacter
    autocmd!
    autocmd BufEnter * let g:completion_trigger_character = ['.']
    autocmd BufEnter *.c,*.cpp,*.rs,*.ino let g:completion_trigger_character = ['.', '::']
augroup end

sign define LspDiagnosticsErrorSign text=✖
sign define LspDiagnosticsWarningSign text=⚠
sign define LspDiagnosticsInformationSign text=ℹ
sign define LspDiagnosticsHintSign text=➤