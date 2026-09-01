local last_edit = vim.api.nvim_create_augroup("last_edit", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    group = last_edit,
    command = [[if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]],
})

local file_types = vim.api.nvim_create_augroup("file_types", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*/playbooks/*.yml" },
    group = file_types,
    command = [[set filetype=yaml.ansible]]
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = '*',
    callback = function(args)
        -- Prevent running on special buffers like telescope or netrw
        if vim.bo[args.buf].buftype ~= "" then return end

        -- Only start if the parser is successfully found. The pcall alone is
        -- not enough: since 0.12 get_parser reports a missing parser by
        -- returning `nil, errmsg` rather than raising, so the call succeeds
        -- and vim.treesitter.start then asserts on the nil. Keep the pcall for
        -- older versions, which do raise, and check the parser itself.
        local ok, parser = pcall(vim.treesitter.get_parser, args.buf)
        if ok and parser then
            vim.treesitter.start(args.buf)
        end
    end,
})
