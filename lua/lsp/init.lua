-- Better looking diagnostic signs
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Setup all the lsp servers
local function setup_servers()
    local sumneko_lua_settings = require("lsp.sumneko_lua")
    local pyright_settings = require("lsp.pyright")
    local rust_analyzer_settings = require("lsp.rust_analyzer")
    local sqlls_settings = require("lsp.sqlls")

    local nvim_lsp = require("lspconfig")

    local common_flags = require("lsp.common")

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

    local callbacks = require("lsp/callbacks")
    local on_attach = callbacks.on_attach
    local on_attach_no_formatting = callbacks.on_attach_no_formatting

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

    local sumneko_lua_config = {
        on_attach = on_attach_no_formatting,
        filetypes = { "lua", ".lua" },
        cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
        settings = sumneko_lua_settings,
        capabilities = capabilities,
        flags = common_flags,
    }

    local rust_analyzer_config = {
        on_attach = on_attach_no_formatting,
        root_dir = nvim_lsp.util.root_pattern("Cargo.toml", ".git"),
        settings = rust_analyzer_settings,
    }

    local pyright_config = {
        on_attach = on_attach,
        filetypes = { "python", ".py" },
        settings = pyright_settings,
        capabilities = capabilities,
        flags = common_flags,
    }

    local sqlls_config = {
        on_attach = on_attach,
        filetypes = { "sql", ".sql" },
        settings = sqlls_settings,
        capabilities = capabilities,
        flags = common_flags,
    }

    local servers = {
        -- Simple server config
        vimls = { on_attach = on_attach },
        html = { on_attach = on_attach },
        cssls = { on_attach = on_attach },
        terraformls = { on_attach = on_attach },
        dockerls = { on_attach = on_attach },
        hls = { on_attach = on_attach },
        yamlls = { on_attach = on_attach_no_formatting },
        jsonls = { on_attach = on_attach_no_formatting },
        bashls = { on_attach = on_attach, filetypes = { "bash", "zsh", "sh" } },
        flow = {
            on_attach = on_attach_no_formatting,
            filetypes = { ".js", ".jsx", "javascript", "javascriptreact", ".js.flow" },
        },
        tsserver = {
            on_attach = on_attach_no_formatting,
            filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
        },
        clangd = { on_attach = on_attach, filetypes = { "c", "ino", "cpp", ".ino" } },

        -- Complex server config
        pyright = pyright_config,
        sqlls = sqlls_config,
        rust_analyzer = rust_analyzer_config,
        sumneko_lua = sumneko_lua_config,
    }

    for lsp, v in pairs(servers) do
        nvim_lsp[lsp].setup({
            on_attach = v.on_attach,
            filetypes = v.filetypes,
            capabilities = v.capabilities or capabilities,
            cmd = v.cmd,
            flags = v.flags or common_flags,
            settings = v.settings,
            root_dir = v.root_dir,
        })
    end

    require("lspsaga").init_lsp_saga({
        code_action_keys = {
            quit = { "q", "<esc>" },
            exec = "<CR>",
        },
        code_action_prompt = {
            enable = true,
            sign = true,
            sign_priority = 40,
            virtual_text = true,
        },
    })
end

return setup_servers
