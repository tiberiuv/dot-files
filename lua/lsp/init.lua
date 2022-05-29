-- Better looking diagnostic signs
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Setup all the lsp servers
local function setup_servers()
    local nvim_lsp = require("lspconfig")
    local common_flags = require("lsp.common")

    -- Servers with custom settings
    local sumneko_lua = require("lsp.sumneko_lua")
    local pyright = require("lsp.pyright")
    local rust_analyzer = require("lsp.rust_analyzer")
    local sqlls = require("lsp.sqlls")

    -- On attach callbacks
    local callbacks = require("lsp/callbacks")
    local on_attach = callbacks.on_attach
    local on_attach_no_formatting = callbacks.on_attach_no_formatting

    -- Server capabilities
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

    local servers = {
        -- Default settings
        vimls = { on_attach = on_attach },
        html = { on_attach = on_attach },
        cssls = { on_attach = on_attach },
        terraformls = { on_attach = on_attach },
        dockerls = { on_attach = on_attach },
        hls = { on_attach = on_attach },
        yamlls = { on_attach = on_attach_no_formatting },
        jsonls = { on_attach = on_attach_no_formatting },
        ansiblels = { on_attach = on_attach_no_formatting },
        bashls = { on_attach = on_attach, filetypes = { "bash", "zsh", "sh" } },
        flow = {
            on_attach = on_attach_no_formatting,
            filetypes = { ".js", ".jsx", "javascript", "javascriptreact", ".js.flow", "svelte" },
        },
        tsserver = {
            on_attach = on_attach_no_formatting,
            filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
        },
        clangd = { on_attach = on_attach, filetypes = { "c", "ino", "cpp", ".ino" } },

        -- Custom settings
        rust_analyzer = { on_attach = on_attach_no_formatting, settings = rust_analyzer.settings },
        sqlls = {
            on_attach = on_attach,
            filetypes = { "sql", ".sql" },
            settings = sqlls.settings,
        },
        pyright = {
            on_attach = on_attach,
            filetypes = { "python", ".py" },
            settings = pyright.settings,
        },
        sumneko_lua = {
            on_attach = on_attach_no_formatting,
            filetypes = { "lua", ".lua" },
            settings = sumneko_lua.settings,
        },
    }

    for lsp, v in pairs(servers) do
        -- Note if a property is not set it will not be overridden
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
end

return setup_servers
