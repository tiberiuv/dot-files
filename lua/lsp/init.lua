require("lsp.servers")

local handlers = vim.lsp.handlers
local pop_opts = {border = "single", max_width = 100}

handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false
    }
)
handlers["textDocument/hover"] = vim.lsp.with(handlers.hover, pop_opts)
handlers["textDocument/signatureHelp"] = vim.lsp.with(handlers.signature_help, pop_opts)
