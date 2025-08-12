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
    local lua_ls = require("lsp.lua_ls")
    local pyright = require("lsp.pyright")

    -- On attach callbacks
    local callbacks = require("lsp/callbacks")
    local on_attach = callbacks.on_attach
    local on_attach_no_formatting = callbacks.on_attach_no_formatting


    local servers = {
        -- Default settings
        vimls = { on_attach = on_attach },
        html = { on_attach = on_attach },
        cssls = { on_attach = on_attach },
        terraformls = { on_attach = on_attach },
        tflint = { on_attach = on_attach },
        dockerls = { on_attach = on_attach },
        hls = { on_attach = on_attach },
        jsonls = { on_attach = on_attach_no_formatting },
        ansiblels = { on_attach = on_attach_no_formatting },
        bashls = { on_attach = on_attach, filetypes = { "bash", "zsh", "sh" } },
        ts_ls = {
            on_attach = on_attach_no_formatting,
            filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
        },
        clangd = { on_attach = on_attach, filetypes = { "c", "ino", "cpp", ".ino" } },
        -- Custom settings
        -- rust_analyzer = { on_attach = on_attach_no_formatting, settings = rust_analyzer.settings },
        pyright = {
            on_attach = on_attach,
            filetypes = { "python", ".py" },
            settings = pyright.settings,
        },
        lua_ls = {
            on_attach = on_attach_no_formatting,
            filetypes = { "lua", ".lua" },
            settings = lua_ls.settings,
        },
        gopls = {
            on_attach = on_attach_no_formatting,
        },
        zls = {
            on_attach = on_attach_no_formatting,
            filetypes = { "zig", ".zig" },
        },
        csharp_ls = { on_attach = on_attach }
    }

    for lsp, v in pairs(servers) do
        -- Note if a property is not set it will not be overridden
        nvim_lsp[lsp].setup({
            on_attach = v.on_attach,
            filetypes = v.filetypes,
            capabilities = require('blink.cmp').get_lsp_capabilities(v.capabilities),
            cmd = v.cmd,
            flags = v.flags or common_flags,
            settings = v.settings,
            root_dir = v.root_dir,
        })
    end

    vim.diagnostic.config({
        -- virtual_text = true,      -- show inline messages
        signs = true,             -- show signs in the gutter
        underline = true,         -- underline problematic text
        update_in_insert = false, -- don't update diagnostics while typing
        severity_sort = true,     -- sort diagnostics by severity
    })

    --[[ map_n("<leader>e", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
    map_n("[e", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts)
    map_n("]e", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts) ]]

    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[e", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]e", vim.diagnostic.goto_next, opts)
end

return setup_servers
