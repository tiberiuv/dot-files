local M = {}

local function map(mode, combo, mapping, opts)
  local options = {noremap = true}
  if opts then
    options = vim.tbl_extend('force', options, opts)
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
