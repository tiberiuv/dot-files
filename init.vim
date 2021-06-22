"---------------------- Vim Rooter -----------------------

let g:rooter_patterns = [
  \ 'package.json',
  \ 'Cargo.toml',
  \ 'Pipfile',
  \ 'pyproject.toml',
  \ 'Makefile',
  \ '.git',
  \]
let g:rooter_silent_chdir = 1
autocmd BufEnter * :Rooter

"----------------- Source config files -------------------

" Load plugins
"source ~/.config/nvim/plugins.vim
" Load lua part of the config
lua require("init")

"------------------------- Fzf --------------------------

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
" Use ctrl-p/f for search using fzf
nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <C-f> :Rg<CR>

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case --glob "!{node_modules,.git,*.lock,target,flow-typed,dist}" -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

"--------------------- Smooth scroll --------------------

noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 5, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 5, 2)<CR>

"--------------------- Key bindings ---------------------

nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>

fun! SetupCommandAlias(from, to)
    exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfun

call SetupCommandAlias("W", "w")
call SetupCommandAlias("Q", "q")
call SetupCommandAlias("q:", "q")
call SetupCommandAlias("Wq", "wq")
call SetupCommandAlias("WQ", "wq")

" run git blame
nnoremap <Leader>s :<C-u>call gitblame#echo()<CR>

"----------------------- NerdTree -----------------------

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

map <silent> <C-n> :call NERDTreeToggleInCurDir()<CR>

let g:NERDTreeLimitedSyntax = 1
let g:WebDevIconsOS = 'Darwin'
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
let g:DevIconsEnableFolderExtensionPatternMatching = 1
let g:NERDTreeHighlightCursorline = 0

augroup nerdtree
    autocmd!
    autocmd StdinReadPre * let s:std_in=1
augroup END

"----------------------- NvimTree -----------------------
"let g:nvim_tree_quit_on_open = 1
"let g:nvim_tree_indent_markers = 1
"let g:nvim_tree_git_hl = 1

"map <silent> <C-n> :NvimTreeToggle<CR>

"----------------------- ALE -----------------------

let g:ale_lint_delay = 200
let g:ale_lint_on_enter = 0
let g:ale_linters_explicit = 1
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 0
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
highlight ALEErrorSign ctermbg=NONE ctermfg=red
highlight ALEWarningSign ctermbg=NONE ctermfg=yellow

let g:ale_python_flake8_args="--max-line-length=100"
let g:ale_rust_rustfmt_options = '--edition 2018'

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
\   'python': ['flake8'],
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
\   'rust': ['rustfmt'],
\   'lua': ['luafmt'],
\}

" Next/previous diagnostics
nmap <silent> [g :ALENext<cr>
nmap <silent> ]g :ALEPrevious<cr>

" run ale_fixers and save
nnoremap <Leader>f :<C-u>ALEFix<CR> \| :w<CR>
noremap Zz <c-w>_ \| <c-w>\|
noremap Zo <c-w>=

"-------------------- Autocmd --------------------

autocmd BufNewFile,BufRead *.jsx setlocal filetype=javascript.jsx
autocmd BufNewFile,BufRead *.tsx setlocal filetype=typescript.tsx
autocmd BufNewFile,BufRead *.ts setlocal filetype=typescript
autocmd BufNewFile,BufRead *.ino,*.pde set filetype=cpp
autocmd BufNewFile,BufRead *.sc setlocal filetype=scala
autocmd BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType rust,python,javascript,typescript,yaml,yml,json autocmd BufWritePre <buffer> %s/\s\+$//e

"---------------------- Settings --------------------------

let g:rainbow_active = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#nvimlsp#enabled = 1
let g:python3_host_prog = '~/pynvim/bin/python'
let g:EditorConfig_exclude_patterns = ['fugitive://.*']
let test#python#runner = 'pyunit'

" Remove Highlight on esc
nmap <silent><ESC> :noh<CR>

"----------------------- Color scheme ----------------------

let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
if has("termguicolors")     " set true colors
    set t_8f=\[[38;2;%lu;%lu;%lum
    set t_8b=\[[48;2;%lu;%lu;%lum
    set termguicolors
endif

set background=dark
let g:gruvbox_contrast_dark='medium'
let g:gruvbox_italic=1
let g:gruvbox_italicize_strings=1
let g:diagnostic_enable_virtual_text=1
silent colorscheme gruvbox

"----------------------- Diagnostic -------------------------

sign define LspDiagnosticsSignError text=✖
sign define LspDiagnosticsSignWarning text=⚠
sign define LspDiagnosticsSingInformation text=ℹ
sign define LspDiagnosticsSignHint text=➤

"--------------------- Floating terminal --------------------

noremap  <C-t>  :FloatermToggle<CR>
noremap! <C-t>  <Esc>:FloatermToggle<CR>
tnoremap <C-t>  <C-\><C-n>:FloatermToggle<CR>

let g:floaterm_width = 100
let g:floaterm_height = 30
let g:floaterm_winblend = 0

"------------------------ Indent lines ---------------------------

let g:indentLine_char_list = ['┆']
let g:indentLine_setColors = 0
let g:indentLine_setConceal = 0
let g:indentLine_enabled = 1

" Only enable for python
augroup identline
  au BufRead,BufNewFile *.py,*.rb let g:indentLine_enabled = 1
  au BufRead,BufNewFile *.py,*.rb let g:indentLine_setConceal = 2
augroup end

"-----------------------------------------------------------------

" Return to last edit position when opening files
augroup last_edit
  autocmd!
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
augroup END

let g:omni_sql_no_default_maps = 1

" Disable Arrow keys in Normal mode
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" Disable Arrow keys in Insert mode
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

let g:vim_markdown_conceal = 1
let g:vim_markdown_conceal_code_blocks = 1
