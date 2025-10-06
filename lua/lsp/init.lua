-- Better looking diagnostic signs

-- Setup all the lsp servers
local function setup_servers()
    local common_flags = require("lsp.common")

    -- Servers with custom settings
    local lua_ls = require("lsp.lua_ls")
    local pyright = require("lsp.pyright")
    local yamlls = require("lsp.yamlls")
    local rustaceanvim = require("lsp.rustaceanvim")

    -- On attach callbacks
    local callbacks = require("lsp/callbacks")
    local on_attach = callbacks.on_attach

    local servers = {
        -- Default settings
        vimls = { on_attach = on_attach },
        html = { on_attach = on_attach },
        cssls = { on_attach = on_attach },
        terraformls = { on_attach = on_attach },
        tflint = { on_attach = on_attach },
        dockerls = { on_attach = on_attach },
        hls = { on_attach = on_attach },
        jsonls = { on_attach = on_attach },
        ansiblels = { on_attach = on_attach },
        bashls = { on_attach = on_attach, filetypes = { "bash", "zsh", "sh" } },
        ts_ls = {
            on_attach = on_attach,
            filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
        },
        clangd = { on_attach = on_attach, filetypes = { "c", "ino", "cpp", ".ino" } },
        ["rust-analyzer"] = rustaceanvim,
        pyright = {
            on_attach = on_attach,
            filetypes = { "python", ".py" },
            settings = pyright.settings,
        },
        lua_ls = {
            on_attach = on_attach,
            filetypes = { "lua", ".lua" },
            settings = lua_ls.settings,
        },
        gopls = {
            on_attach = on_attach,
        },
        zls = {
            on_attach = on_attach,
            filetypes = { "zig", ".zig" },
        },
        csharp_ls = { on_attach = on_attach },
    }

    for lsp, v in pairs(servers) do
        -- Note if a property is not set it will not be overridden
        vim.lsp.config(lsp, {
            on_attach = v.on_attach,
            filetypes = v.filetypes,
            capabilities = require("blink.cmp").get_lsp_capabilities(v.capabilities),
            cmd = v.cmd,
            flags = v.flags or common_flags,
            settings = v.settings,
            root_dir = v.root_dir,
        })
        vim.lsp.enable(lsp)
    end

    local schema_lsps = {
        yamlls = yamlls,
    }

    for lsp, v in pairs(schema_lsps) do
        vim.lsp.config(lsp, v)
        vim.lsp.enable(lsp)
    end

    local _signs = { ERROR = "󰅙", WARN = "", HINT = "", INFO = "󰋼" }
    local signs = {
        text = {},
        linehl = {},
        numhl = {},
    }

    local severity = vim.diagnostic.severity
    for type, icon in pairs(_signs) do
        local hl = "DiagnosticSign" .. type
        signs.text[severity[type]] = icon
        signs.linehl[severity[type]] = ""
        signs.numhl[severity[type]] = hl
    end

    vim.diagnostic.config({
        -- virtual_text = true,      -- show inline messages
        underline = true, -- underline problematic text
        update_in_insert = false, -- don't update diagnostics while typing
        severity_sort = true, -- sort diagnostics by severity
        signs = signs,
    })

    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[e", function()
        vim.diagnostic.jump({ count = -1, float = true })
    end, opts)
    vim.keymap.set("n", "]e", function()
        vim.diagnostic.jump({ count = 1, float = true })
    end, opts)
end

return setup_servers
