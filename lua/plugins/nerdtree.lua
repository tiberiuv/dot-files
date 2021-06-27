local map = require"utils".map


vim.api.nvim_command("augroup nerdtree")
vim.api.nvim_command("autocmd!")
vim.api.nvim_command("autocmd StdinReadPre * let s:std_in=1")
vim.api.nvim_command("augroup END")

vim.g["NERDTreeLimitedSyntax"] = 1
vim.g["NERDTreeHighlightCursorline"] = 0
vim.g["NERDTreeQuitOnOpen"] = 1
vim.g["NERDTreeIgnore"] = {"__pycache__"}

vim.cmd[[
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
]]


map("", "<C-n>", ":call NERDTreeToggleInCurDir()<CR>", {silent = true})
