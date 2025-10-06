local on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true }

    local function map_n(...)
        vim.api.nvim_buf_set_keymap(bufnr, "n", ...)
    end

    -- Mappings.
    map_n("<C-s>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
    map_n("<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", opts)
    map_n("<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", opts)
    map_n("<leader>wl", "<cmd>lua vim.lsp.buf.list_workspace_folders()<cr>", opts)
    map_n("<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
    map_n("<leader>f", "<cmd>lua vim.lsp.buf.format()<cr> <cmd>:w<cr>", opts)

    map_n("<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
    map_n("K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)

    map_n("<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
    map_n("gd", "<cmd>lua require'telescope.builtin'.lsp_definitions()<cr>", opts)
    map_n("gi", "<cmd>lua require'telescope.builtin'.lsp_implementations()<cr>", opts)
    map_n("gr", "<cmd>lua require'telescope.builtin'.lsp_references()<cr>", opts)

    local handlers = vim.lsp.handlers
    local pop_opts = { border = "single", max_width = 100 }

    handlers["textDocument/hover"] = vim.lsp.with(handlers.hover, pop_opts)
    handlers["textDocument/signatureHelp"] = vim.lsp.with(handlers.signature_help, pop_opts)
    if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true)
    end
end

local on_attach_no_formatting = function(client, bufnr)
    client.server_capabilities.document_formatting = false
    on_attach(client, bufnr)
end

return {
    on_attach = on_attach,
    on_attach_no_formatting = on_attach_no_formatting,
}
