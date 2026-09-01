local opt = require("utils").opt

-- Global
-----------------------------------------------
vim.g.python3_host_prog = "~/pynvim/bin/python"
vim.g.cursorhold_updatetime = 100
opt.cmdheight = 0
opt.hidden = true
opt.wildmenu = true
opt.laststatus = 3
opt.showmatch = true
opt.updatetime = 200
opt.autoread = true
opt.lazyredraw = true
opt.encoding = "UTF-8"
opt.smarttab = true
opt.backspace = "indent,eol,start"
opt.completeopt = "menu,menuone,noselect"
opt.ruler = false
opt.showcmd = false
opt.mouse = ""
opt.termguicolors = true

-- Over ssh there is no local X/Wayland display, so nvim's xclip/wl-copy
-- providers write into a clipboard nobody can see (or fail outright). OSC 52
-- hands the yank to the terminal emulator on *this* side of the connection
-- instead, which is what makes `"*y` work remotely. Paste stays on the
-- unnamed register: OSC 52 reads are refused by most terminals.
if vim.env.SSH_TTY then
    local osc52 = require("vim.ui.clipboard.osc52")
    vim.g.clipboard = {
        name = "OSC 52",
        copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
        paste = { ["+"] = function() return {} end, ["*"] = function() return {} end },
    }
end

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
opt.synmaxcol = 400

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99
opt.syntax = 'on'
