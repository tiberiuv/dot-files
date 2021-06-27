require "lualine".setup {
    options = {theme = "gruvbox"},
    sections = {
        lualine_a = {"mode"},
        lualine_b = {"branch"},
        lualine_c = {
            {
                "filename",
                path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
            }
        },
        lualine_x = {"encoding", "fileformat", "filetype"},
        lualine_y = {
            {
                "diff",
                colored = true, -- displays diff status in color if set to true
                -- all colors are in format #rrggbb
                color_added = nil, -- changes diff's added foreground color
                color_modified = nil, -- changes diff's modified foreground color
                color_removed = nil, -- changes diff's removed foreground color
                symbols = {added = "+", modified = "~", removed = "-"} -- changes diff symbols
            }
        },
        lualine_z = {
            "progres",
            "location",
            {
                "diagnostics",
                -- table of diagnostic sources, available sources:
                -- nvim_lsp, coc, ale, vim_lsp
                sources = {"nvim_lsp", "ale"},
                -- displays diagnostics from defined severity
                sections = {"error", "warn", "info", "hint"},
                -- all colors are in format #rrggbb
                color_error = nil, -- changes diagnostic's error foreground color
                color_warn = nil, -- changes diagnostic's warn foreground color
                color_info = nil, -- Changes diagnostic's info foreground color
                color_hint = nil, -- Changes diagnostic's hint foreground color
                symbols = {error = "E", warn = "W", info = "I", hint = "H"}
            }
        }
    }
}
