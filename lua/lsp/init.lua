-- Better looking diagnostic signs
local signs = {Error = " ", Warn = " ", Hint = " ", Info = " "}

for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = ""})
end

-- Setup all the lsp servers
local function setup_servers()
    local configs = require("lspconfig/configs")
    local nvim_lsp = require("lspconfig")

    local common_flags = require("lsp.common")

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

    local callbacks = require("lsp/callbacks")
    local on_attach = callbacks.on_attach
    local on_attach_no_formatting = callbacks.on_attach_no_formatting

    configs.pyright = {
        on_attach = on_attach,
        filetypes = {"python", ".py"},
        default_config = {
            cmd = {"pyright-langserver", "--stdio"},
            filetypes = {"python"},
            root_dir = nvim_lsp.util.root_pattern("Pipfile", "requirements.txt",
                                                  ".git", "setup.py",
                                                  "setup.cfg", "pyproject.toml"),
            settings = {
                analysis = {
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true
                },
                pyright = {
                    useLibraryCodeForTypes = true,
                    venvPath = "~/.local/share/virtualenvs",
                    reportMissingImports = true
                }
            }
        },
        capabilities = capabilities,
        flags = common_flags
    }

    nvim_lsp.tsserver.setup {
        on_attach = on_attach,
        filetypes = {"typescript", "typescriptreact", "typescript.tsx"},
        capabilities = capabilities,
        flags = common_flags
    }

    nvim_lsp.clangd.setup {
        on_attach = on_attach,
        filetypes = {"c", "ino", "cpp", ".ino"},
        capabilities = capabilities,
        flags = common_flags
    }

    nvim_lsp.metals.setup {
        on_attach = on_attach,
        filetypes = {"scala", ".sc", ".scala"},
        capabilities = capabilities,
        flags = common_flags
    }

    nvim_lsp.flow.setup {
        on_attach = on_attach_no_formatting,
        capabilities = capabilities,
        flags = common_flags,
        filetypes = {".js", ".jsx", "javascript", "javascriptreact"}
    }

    nvim_lsp.sqls.setup {
        on_attach = on_attach,
        filetypes = {"sql", ".sql"},
        settings = {
            sqls = {
                connections = {
                    {
                        drive = "postgresql",
                        dataSourceName = "host=postgres port=5430 user=newuser password=password dbname=core sslmode=disable"
                    }
                }
            }
        },
        capabilities = capabilities,
        flags = common_flags
    }

    local system_name
    if vim.fn.has("mac") == 1 then
        system_name = "macOS"
    elseif vim.fn.has("unix") == 1 then
        system_name = "Linux"
    elseif vim.fn.has("win32") == 1 then
        system_name = "Windows"
    else
        print("Unsupported system for sumneko")
    end

    local sumneko_root_path = os.getenv("HOME") ..
                                  "/.zinit/plugins/sumneko---lua-language-server"
    local sumneko_binary = sumneko_root_path .. "/bin/" .. system_name ..
                               "/lua-language-server"

    nvim_lsp.sumneko_lua.setup {
        on_attach = on_attach,
        filetypes = {"lua", ".lua"},
        cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
        settings = {
            Lua = {
                runtime = {
                    -- Get the language server to recognize LuaJIT globals like `jit` and `bit`
                    version = "LuaJIT",
                    -- Setup your lua path
                    path = vim.split(package.path, ";")
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = {"vim"}
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true)
                },
                telemetry = {enabled = false}
            }
        },
        capabilities = capabilities,
        flags = common_flags
    }

    nvim_lsp.rust_analyzer.setup {
        on_attach = on_attach_no_formatting,
        filetypes = {"rust", ".rs"},
        root_dir = nvim_lsp.util.root_pattern("Cargo.toml", ".git"),
        settings = {
            ["rust-analyzer"] = {
                diagnostics = {enable = true, enableExperimental = true},
                inlayHints = {
                    enable = true,
                    parameterHints = true,
                    typeHints = true
                },
                checkOnSave = {
                    command = "clippy",
                    extraArgs = {"--tests"},
                    allTargets = false
                },
                assist = {
                    importGranularity = "module",
                    importPrefix = "by_self"
                },
                cargo = {
                    loadOutDirsFromCheck = true,
                    target = os.getenv("RUST_ANALYZER_TARGET"),
                    allFeatures = true
                },
                procMacro = {enable = true},
                experimental = {procAttrMacros = true},
                lruCapacity = 256
            }
        },
        capabilities = capabilities,
        flags = common_flags
    }

    nvim_lsp.bashls.setup {filetypes = {"bash", "zsh"}, on_attach = on_attach}

    local servers = {
        "vimls",
        "jsonls",
        "html",
        "cssls",
        "terraformls",
        "dockerls",
        "texlab",
        "yamlls",
        "pyright"
    }

    for _, lsp in ipairs(servers) do
        local _on_attach = function(client, bufnr)
            -- using prettier instead for formatting
            if lsp == "jsonls" or lsp == "yamlls" then
                on_attach_no_formatting(client, bufnr)
            else
                on_attach(client, bufnr)
            end
        end
        nvim_lsp[lsp].setup {
            on_attach = _on_attach,
            capabilities = capabilities,
            flags = common_flags
        }
    end

    local linters = require("lsp.linters")
    local formatters = require("lsp.formatters")

    nvim_lsp.diagnosticls.setup {
        on_attach = on_attach,
        filetypes = vim.tbl_keys(formatters.formatFiletypes),
        init_options = {
            filetypes = linters.linter_filetypes,
            linters = linters.linters,
            formatters = formatters.formatters,
            formatFiletypes = formatters.formatFiletypes
        }
    }

end

return setup_servers
