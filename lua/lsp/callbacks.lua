local on_attach = function(_, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    require"lsp_extensions".inlay_hints {
        highlight = "Comment",
        prefix = " > ",
        aligned = false,
        only_current_line = false,
        enabled = {"ChainingHint"},
        use_languagetree = true
    }

    -- Mappings.
    local opts = {noremap = true, silent = true}
    buf_set_keymap("n", "gD", "<CMD>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gd", "<CMD>lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "K", "<CMD>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "gi", "<CMD>lua vim.lsp.buf.implementation()<CR>", opts)
    buf_set_keymap("n", "<C-s>", "<CMD>lua vim.lsp.buf.signature_help()<CR>",
                   opts)
    buf_set_keymap("n", "<leader>wa",
                   "<CMD>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
    buf_set_keymap("n", "<leader>wr",
                   "<CMD>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
    buf_set_keymap("n", "<leader>wl",
                   "<CMD>lua vim.lsp.buf.list_workspace_folders()<CR>", opts)
    buf_set_keymap("n", "<leader>D",
                   "<CMD>lua vim.lsp.buf.type_definition()<CR>", opts)
    buf_set_keymap("n", "<leader>rn", "<CMD>lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap("n", "gr", "<CMD>lua vim.lsp.buf.references()<CR>", opts)
    buf_set_keymap("n", "<leader>ca", "<Cmd>lua vim.lsp.buf.code_action()<CR>",
                   opts)
    buf_set_keymap("n", "[e", "<CMD>lua vim.lsp.diagnostic.goto_prev()<CR>",
                   opts)
    buf_set_keymap("n", "]e", "<CMD>lua vim.lsp.diagnostic.goto_next()<CR>",
                   opts)
    buf_set_keymap("n", "<leader>e",
                   "<CMD>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>",
                   opts)
    buf_set_keymap("n", "<leader>f", "<CMD>lua vim.lsp.buf.formatting()<CR>",
                   opts)
    buf_set_keymap("n", "<leader>f",
                   "<CMD>lua vim.lsp.buf.formatting_sync()<CR> <CMD>:w<CR>",
                   opts)

    local handlers = vim.lsp.handlers
    local pop_opts = {border = "single", max_width = 100}

    handlers["textDocument/publishDiagnostics"] =
        vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = true,
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true
        })
    handlers["textDocument/hover"] = vim.lsp.with(handlers.hover, pop_opts)
    handlers["textDocument/signatureHelp"] = vim.lsp.with(
                                                 handlers.signature_help,
                                                 pop_opts)
end

local on_attach_no_formatting = function(client, bufnr)
    client.resolved_capabilities.document_formatting = false
    on_attach(client, bufnr)
end

return {
    on_attach = on_attach,
    on_attach_no_formatting = on_attach_no_formatting
}
