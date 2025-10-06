local on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true }

    local function map_n(...)
        vim.api.nvim_buf_set_keymap(bufnr, "n", ...)
    end

    -- Mappings.
    map_n("<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", opts)
    map_n("<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", opts)
    map_n("<leader>wl", "<cmd>lua vim.lsp.buf.list_workspace_folders()<cr>", opts)
    map_n("<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)

    map_n("<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
    vim.keymap.set("n", "K", function()
        vim.lsp.buf.hover({ border = "single", max_width = 100 })
    end, opts)
    vim.keymap.set("n", "<C-s>", function()
        vim.lsp.buf.signature_help({ border = "single", max_width = 100 })
    end, opts)
    vim.keymap.set("n", "<leader>f", function()
        require("conform").format({
            bufnr = bufnr,
        }, function()
            vim.cmd(":w")
        end)
    end, opts)

    map_n("<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
    map_n("gd", "<cmd>lua require'telescope.builtin'.lsp_definitions()<cr>", opts)
    map_n("gi", "<cmd>lua require'telescope.builtin'.lsp_implementations()<cr>", opts)
    map_n("gr", "<cmd>lua require'telescope.builtin'.lsp_references()<cr>", opts)

    if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true)
    end
end

return {
    on_attach = on_attach,
}
