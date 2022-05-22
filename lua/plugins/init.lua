local execute = vim.api.nvim_command
local fn = vim.fn

-- ensure that packer is installed
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
        "git",
        "clone",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
    execute("packadd packer.nvim")
end

local packer = require("packer")
local util = require("packer.util")

vim.cmd("autocmd BufWritePost plugins/packer.lua PackerCompile")
local au = vim.api.nvim_create_augroup("packer", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "BufWritePost plugins/init.lua",
    group = au,
    command = "PackerCompile",
})

packer.init({
    package_root = util.join_paths(vim.fn.stdpath("data"), "site", "pack"),
})

require("plugins.install_plugins")
