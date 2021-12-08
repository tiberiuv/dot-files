local on_attach = function(_, bufnr)
    require("lsp_extensions").inlay_hints({
        highlight = "Comment",
        prefix = " > ",
        aligned = false,
        only_current_line = false,
        enabled = { "ChainingHint" },
        use_languagetree = true,
    })

    local opts = { noremap = true, silent = true }

    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    local function set_keymap_n(...)
        vim.api.nvim_buf_set_keymap(bufnr, "n", ...)
    end

    -- Mappings.
    set_keymap_n("gD", "<CMD>lua vim.lsp.buf.declaration()<CR>", opts)
    set_keymap_n("gd", "<CMD>lua vim.lsp.buf.definition()<CR>", opts)
    set_keymap_n("K", "<CMD>lua vim.lsp.buf.hover()<CR>", opts)
    set_keymap_n("gi", "<CMD>lua vim.lsp.buf.implementation()<CR>", opts)
    set_keymap_n("<C-s>", "<CMD>lua vim.lsp.buf.signature_help()<CR>", opts)
    set_keymap_n("<leader>wa", "<CMD>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
    set_keymap_n("<leader>wr", "<CMD>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
    set_keymap_n("<leader>wl", "<CMD>lua vim.lsp.buf.list_workspace_folders()<CR>", opts)
    set_keymap_n("<leader>D", "<CMD>lua vim.lsp.buf.type_definition()<CR>", opts)
    set_keymap_n("<leader>rn", "<CMD>lua vim.lsp.buf.rename()<CR>", opts)
    set_keymap_n("gr", "<CMD>lua vim.lsp.buf.references()<CR>", opts)
    set_keymap_n("<leader>ca", "<Cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    set_keymap_n("[e", "<CMD>lua vim.diagnostic.goto_prev()<CR>", opts)
    set_keymap_n("]e", "<CMD>lua vim.diagnostic.goto_next()<CR>", opts)
    set_keymap_n("<leader>e", "<CMD>lua vim.diagnostic.open_float()<CR>", opts)
    set_keymap_n("<leader>f", "<CMD>lua vim.lsp.buf.formatting()<CR>", opts)
    set_keymap_n("<leader>f", "<CMD>lua vim.lsp.buf.formatting_sync()<CR> <CMD>:w<CR>", opts)

    local handlers = vim.lsp.handlers
    local pop_opts = { border = "single", max_width = 100 }

    handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
    })
    handlers["textDocument/hover"] = vim.lsp.with(handlers.hover, pop_opts)
    handlers["textDocument/signatureHelp"] = vim.lsp.with(handlers.signature_help, pop_opts)
end

local on_attach_no_formatting = function(client, bufnr)
    client.resolved_capabilities.document_formatting = false
    on_attach(client, bufnr)
end

return {
    on_attach = on_attach,
    on_attach_no_formatting = on_attach_no_formatting,
}
