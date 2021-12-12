local opts_info = vim.api.nvim_get_all_options_info()

local opt = setmetatable({}, {
    __newindex = function(_, key, value)
        vim.o[key] = value
        local scope = opts_info[key].scope
        if scope == "win" then
            vim.wo[key] = value
        elseif scope == "buf" then
            vim.bo[key] = value
        end
    end,
})

local function map(mode, combo, mapping, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    if type(mode) == "table" then
        for _, value in ipairs(mode) do
            vim.api.nvim_set_keymap(value, combo, mapping, options)
        end
    else
        vim.api.nvim_set_keymap(mode, combo, mapping, options)
    end
end

local function require_reset(pck)
    package.loaded[pck] = nil
    require(pck)
end

return { require_reset = require_reset, map = map, opt = opt }
