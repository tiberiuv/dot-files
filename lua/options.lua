local o = vim.o
local wo = vim.wo
local bo = vim.bo
local cmd = vim.cmd

cmd "syntax enable"
cmd "filetype plugin indent on"

-- Global
-----------------------------------------------
o.cmdheight = 2
o.hidden = true
o.wildmenu = true
o.laststatus = 2
o.showmatch = true
o.updatetime = 200
o.autoread = true
o.lazyredraw = true
o.encoding = "UTF-8"
o.smarttab = true
o.backspace = "indent,eol,start"
o.ruler = false
o.completeopt = "menu,noinsert,noselect"
o.showcmd = false

-- Search
o.ignorecase = true
o.smartcase = true
o.incsearch = true
o.hlsearch = true

o.grepprg = "rg --vimgrep --no-heading --smart-case"
o.grepformat = "%f:%l:%c:%m"
o.undofile = true

o.shortmess = vim.o.shortmess .. "c"
o.colorcolumn = "100"

-- Window local
-----------------------------------------------
wo.wrap = true
wo.cursorline = true
wo.number = true
wo.relativenumber = true
wo.signcolumn = "yes"

-- Buffer local
-----------------------------------------------
bo.autoindent = true
bo.tabstop = 4
bo.shiftwidth = 4
bo.softtabstop = 4
bo.expandtab = true
bo.synmaxcol = 200

-- Global vars
-----------------------------------------------
vim.g["cursorhold_updatetime"] = 100
