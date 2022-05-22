local on_attach = function(_, bufnr)
    require("lsp_extensions").inlay_hints({
        highlight = "Comment",
        prefix = " > ",
        aligned = false,
        only_current_line = false,
        enabled = { "ChainingHint", "TypeHint" },
        use_languagetree = true,
    })

    local opts = { noremap = true, silent = true }

    local function map_n(...)
        vim.api.nvim_buf_set_keymap(bufnr, "n", ...)
    end

    -- Mappings.
    map_n("gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
    map_n("gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
    map_n("gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
    map_n("<C-s>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
    map_n("<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", opts)
    map_n("<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", opts)
    map_n("<leader>wl", "<cmd>lua vim.lsp.buf.list_workspace_folders()<cr>", opts)
    map_n("<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
    map_n("gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
    map_n("<leader>e", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
    --map_n("<leader>f", "<cmd>lua vim.lsp.buf.formatting()<cr>", opts)
    map_n("<leader>f", "<cmd>lua vim.lsp.buf.format()<cr> <cmd>:w<cr>", opts)

    map_n("<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
    map_n("<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
    map_n("K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
    map_n("[e", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts)
    map_n("]e", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts)

    map_n("<leader>rn", "<cmd>lua require('lspsaga.rename').rename()<cr>", opts)
    map_n("<leader>ca", "<cmd>lua require('lspsaga.codeaction').code_action()<cr>", opts)
    map_n("K", "<cmd>lua require('lspsaga.hover').render_hover_doc()<cr>", opts)
    map_n("vd", "<cmd>lua require('lspsaga.provider').preview_definition()<cr>", opts)
    map_n("[e", "<cmd>Lspsaga diagnostic_jump_prev<cr>", opts)
    map_n("]e", "<cmd>Lspsaga diagnostic_jump_next<cr>", opts)

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
    client.server_capabilities.document_formatting = false
    on_attach(client, bufnr)
end

return {
    on_attach = on_attach,
    on_attach_no_formatting = on_attach_no_formatting,
}
