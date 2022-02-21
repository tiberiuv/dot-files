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

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

    local callbacks = require("lsp/callbacks")
    local on_attach = callbacks.on_attach
    local on_attach_no_formatting = callbacks.on_attach_no_formatting

    nvim_lsp.pyright.setup({
        on_attach = on_attach,
        filetypes = { "python", ".py" },
        settings = {
            python = {
                analysis = {
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                },
            },
        },
        capabilities = capabilities,
        flags = {
            lsp_flags = { debounce_text_changes = 150 },
            allow_incremental_sync = false,
        },
    })

    nvim_lsp.sqls.setup({
        on_attach = on_attach,
        filetypes = { "sql", ".sql" },
        settings = {
            sqls = {
                connections = {
                    {
                        drive = "postgresql",
                        dataSourceName = "host=postgres port=5430 user=newuser password=password dbname=core sslmode=disable",
                    },
                },
            },
        },
        capabilities = capabilities,
        flags = common_flags,
    })

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

    nvim_lsp.sumneko_lua.setup({
        on_attach = on_attach_no_formatting,
        filetypes = { "lua", ".lua" },
        cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
        settings = {
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
        },
        capabilities = capabilities,
        flags = common_flags,
    })

    nvim_lsp.rust_analyzer.setup({
        on_attach = on_attach_no_formatting,
        filetypes = { "rust", ".rs" },
        root_dir = nvim_lsp.util.root_pattern("Cargo.toml", ".git"),
        settings = {
            ["rust-analyzer"] = {
                diagnostics = { enable = true, enableExperimental = true },
                inlayHints = {
                    enable = true,
                    parameterHints = true,
                    typeHints = true,
                },
                checkOnSave = {
                    command = "clippy",
                    extraArgs = { "--tests" },
                    allTargets = false,
                },
                assist = {
                    importGranularity = "module",
                    importPrefix = "by_self",
                },
                cargo = {
                    loadOutDirsFromCheck = true,
                    target = os.getenv("RUST_ANALYZER_TARGET"),
                    allFeatures = true,
                },
                procMacro = { enable = true },
                experimental = { procAttrMacros = true },
                lruCapacity = 256,
            },
        },
        capabilities = capabilities,
        flags = common_flags,
    })

    -- Simple servers
    local simple_servers = {
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
    }

    for lsp, v in pairs(simple_servers) do
        nvim_lsp[lsp].setup({
            on_attach = v.on_attach,
            filetypes = v.filetypes,
            capabilities = capabilities,
            flags = common_flags,
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
