-- Install lsp servers
local nvim_lsp = require("lspconfig")
local configs = require("lspconfig/configs")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local on_attach = function(_, bufnr)
    require "lsp_extensions".inlay_hints {
        highlight = "Comment",
        prefix = " > ",
        aligned = false,
        only_current_line = false,
        enabled = {"ChainingHint"},
        use_languagetree = true
    }

    -- Mappings.
    local opts = {noremap = true, silent = true}
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-s>", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wa", "<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wr", "<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wl", "<Cmd>lua vim.lsp.buf.list_workspace_folders()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>D", "<Cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<Cmd>lua vim.lsp.buf.rename()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<Cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<leader>e",
        "<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>",
        opts
    )
    -- Lsp saga key binds
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<leader>ca",
        "<cmd>lua require('lspsaga.codeaction').code_action()<CR>",
        opts
    )
    -- Broken until lsp saga is updated, following nvim nightly breakage
    -- https://github.com/neovim/neovim/pull/15504

    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<Cmd>lua require('lspsaga.hover').render_hover_doc()<CR>", opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "vd", "<Cmd>lua require'lspsaga.provider'.preview_definition()<CR>", opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<Cmd>lua require('lspsaga.rename').rename()<CR>", opts)
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "[e",
        "<Cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>",
        opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "]e",
        "<Cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>",
        opts
    )
end

configs.pyright = {
    filetypes = {"python", ".py"},
    default_config = {
        cmd = {"pyright-langserver", "--stdio"},
        filetypes = {"python"},
        root_dir = nvim_lsp.util.root_pattern(
            "Pipfile",
            "requirements.txt",
            ".git",
            "setup.py",
            "setup.cfg",
            "pyproject.toml"
        ),
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
    capabilities = capabilities
}

nvim_lsp.tsserver.setup {
    on_attach = on_attach,
    filetypes = {"typescript", "typescriptreact", "typescript.tsx"},
    capabilities = capabilities
}

nvim_lsp.clangd.setup {
    on_attach = on_attach,
    filetypes = {"c", "ino", "cpp", ".ino"},
    capabilities = capabilities
}

nvim_lsp.metals.setup {
    on_attach = on_attach,
    filetypes = {"scala", ".sc", ".scala"},
    capabilities = capabilities
}

nvim_lsp.flow.setup {
    on_attach = on_attach,
    capabilities = capabilities
    -- filetypes = {"javascriptflow.jsx", "javascriptflow.js"}
}

nvim_lsp.sqls.setup {
    on_attach = on_attach,
    settings = {
        sqls = {
            connections = {
                {
                    drive = "postgresql",
                    --dataSourceName = "newuser:password@tcp(127.0.0.1:5430)/watcher"
                    dataSourceName = "host=postgres port=5430 user=newuser password=password dbname=core sslmode=disable"
                }
            }
        }
    },
    capabilities = capabilities
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

local sumneko_root_path = os.getenv("HOME") .. "/.zinit/plugins/sumneko---lua-language-server"
local sumneko_binary = sumneko_root_path .. "/bin/" .. system_name .. "/lua-language-server"

nvim_lsp.sumneko_lua.setup {
    filetypes = {"lua", ".lua"},
    on_attach = on_attach,
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
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
                }
            }
        }
    },
    capabilities = capabilities
}

nvim_lsp.rust_analyzer.setup {
    filetypes = {"rust", ".rs"},
    on_attach = on_attach,
    root_dir = nvim_lsp.util.root_pattern("Cargo.toml", ".git"),
    settings = {
        ["rust-analyzer"] = {
            diagnostics = {
                enable = true,
                enableExperimental = true
            },
            inlayHints = {
                enable = true,
                parameterHints = true,
                typeHints = true
            },
            checkOnSave = {
                command = "clippy",
                allTargets = true
            },
            assist = {
                importGranularity = "module",
                importPrefix = "by_self"
            },
            cargo = {
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            }
        }
    },
    capabilities = capabilities
}

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
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities
    }
end

vim.lsp.handlers["textDocument/codeAction"] = require "lsputil.codeAction".code_action_handler
vim.lsp.handlers["textDocument/references"] = require "lsputil.locations".references_handler
vim.lsp.handlers["textDocument/definition"] = require "lsputil.locations".definition_handler
vim.lsp.handlers["textDocument/declaration"] = require "lsputil.locations".declaration_handler
vim.lsp.handlers["textDocument/typeDefinition"] = require "lsputil.locations".typeDefinition_handler
vim.lsp.handlers["textDocument/implementation"] = require "lsputil.locations".implementation_handler
vim.lsp.handlers["textDocument/documentSymbol"] = require "lsputil.symbols".document_handler
vim.lsp.handlers["workspace/symbol"] = require "lsputil.symbols".workspace_handler
vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
        underline = true,
        virtual_text = true,
        signs = true,
        update_in_insert = false
    }
)
