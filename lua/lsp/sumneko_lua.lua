local system_name
if vim.fn.has("mac") == 1 then
    system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
    system_name = "Linux"
else
    print("Unsupported system for sumneko")
end

local sumneko_root_path = os.getenv("HOME") .. "/.zinit/plugins/sumneko---lua-language-server"
local sumneko_binary = sumneko_root_path .. "/bin/" .. system_name .. "/lua-language-server"

local sumneko_lua_settings = {
    Lua = {
        runtime = {
            -- Get the language server to recognize LuaJIT globals like `jit` and `bit`
            version = "LuaJIT",
            -- Setup your lua path
            path = vim.split(package.path, ";"),
        },
        diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { "vim" },
        },
        workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
        },
        telemetry = { enabled = false },
    },
}

return {settings = sumneko_lua_settings, bin = sumneko_binary, path = sumneko_root_path}
