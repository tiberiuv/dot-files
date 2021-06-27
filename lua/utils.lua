local M = {}
local opts_info = vim.api.nvim_get_all_options_info()

local opt =
    setmetatable(
    {},
    {
        __newindex = function(self, key, value)
            vim.o[key] = value
            local scope = opts_info[key].scope
            if scope == "win" then
                vim.wo[key] = value
            elseif scope == "buf" then
                vim.bo[key] = value
            end
        end
    }
)
M.opt = opt

local function map(mode, combo, mapping, opts)
    local options = {noremap = true}
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, combo, mapping, options)
end
M.map = map

local function require_reset(pck)
    package.loaded[pck] = nil
    require(pck)
end

M.require_reset = require_reset

return M
