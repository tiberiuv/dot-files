local opt = require("utils").opt

-- Global
-----------------------------------------------
opt.cmdheight = 2
opt.hidden = true
opt.wildmenu = true
opt.laststatus = 2
opt.showmatch = true
opt.updatetime = 200
opt.autoread = true
opt.lazyredraw = true
opt.encoding = "UTF-8"
opt.smarttab = true
opt.backspace = "indent,eol,start"
opt.ruler = false
opt.showcmd = false

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

opt.grepprg = "rg --vimgrep --no-heading --smart-case"
opt.grepformat = "%f:%l:%c:%m"
opt.undofile = true

opt.shortmess = vim.o.shortmess .. "c"
opt.colorcolumn = "80"

-- Window local
-----------------------------------------------
opt.wrap = true
opt.cursorline = true
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"

-- Buffer local
-----------------------------------------------
opt.autoindent = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.synmaxcol = 200
