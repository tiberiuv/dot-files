"----------------- Source config files -------------------

" Load lua part of the config
lua require("init")

"------------------------- Fzf --------------------------

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case --glob "!{node_modules,.git,*.lock,target,flow-typed,dist}" -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

"--------------------- Key bindings ---------------------

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

"-----------------------------------------------------------------

" Return to last edit position when opening files
augroup last_edit
  autocmd!
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
augroup END
