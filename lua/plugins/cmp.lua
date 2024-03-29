local has_words_before = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        { "L3MON4D3/LuaSnip" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-path" },
        { "saadparwaiz1/cmp_luasnip" },
    },
    event = "InsertEnter",
    config = function()
        local compare = require("cmp.config.compare")

        local cmp_kinds = {
            Field = { icon = "󰜢", order = 11 },
            Property = { icon = "󰜢", order = 11 },
            Constant = { icon = "󰏿", order = 10 },
            Enum = { icon = "", order = 10 },
            EnumMember = { icon = "", order = 10 },
            Copilot = { icon = "", order = 10 },
            Event = { icon = "", order = 10 },
            Function = { icon = "󰊕", order = 10 },
            Method = { icon = "󰆧", order = 10 },
            Operator = { icon = "󰆕", order = 10 },
            Reference = { icon = "󰈇", order = 10 },
            Struct = { icon = "󰙅", order = 10 },
            Variable = { icon = "󰀫", order = 9 },
            File = { icon = "󰈙", order = 8 },
            Folder = { icon = "󰉋", order = 8 },
            Class = { icon = "󰠱", order = 5 },
            Color = { icon = "󰏘", order = 5 },
            Module = { icon = "", order = 5 },
            Keyword = { icon = "", order = 2 },
            Constructor = { icon = "", order = 1 },
            Interface = { icon = "", order = 1 },
            Text = { icon = "󰉿", order = 1 },
            Unit = { icon = "塞", order = 1 },
            Value = { icon = "󰎠", order = 1 },
            TypeParameter = { icon = "", order = 1 },
            Snippet = { icon = "", order = 0 },
        }

        local lspkind_comparator = function(conf)
            local lsp_types = require("cmp.types").lsp
            return function(entry1, entry2)
                if entry1.source.name ~= "nvim_lsp" then
                    if entry2.source.name == "nvim_lsp" then
                        return false
                    else
                        return nil
                    end
                end
                local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
                local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]

                local priority1 = conf[kind1].order or 0
                local priority2 = conf[kind2].order or 0
                if priority1 == priority2 then
                    return nil
                end
                return priority2 < priority1
            end
        end

        local label_comparator = function(entry1, entry2)
            return entry1.completion_item.label < entry2.completion_item.label
        end

        local cmp = require("cmp")

        local mapping = {
            ["<C-p>"] = cmp.mapping.select_prev_item(),
            ["<C-n>"] = cmp.mapping.select_next_item(),
            ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
            ["<C-e>"] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
            }),
            ["<CR>"] = cmp.mapping.confirm(),
            ["<Tab>"] = vim.schedule_wrap(function(fallback)
                if cmp.visible() and has_words_before() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                else
                    fallback()
                end
            end)
        }
        local opts = {
            mapping = mapping,
            completion = { completeopt = "menu,menuone,noselect", keyword_length = 2 },
            sources = { { name = "copilot" }, { name = "nvim_lsp" }, { name = "luasnip" },
                { name = "path" } },
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            formatting = {
                format = function(entry, vim_item)
                    local kind = cmp_kinds[vim_item.kind].icon .. " " .. vim_item.kind
                    vim_item.kind = kind

                    vim_item.menu = ({
                        nvim_lsp = "[LSP]",
                        luasnip = "[Snp]",
                        buffer = "[Buf]",
                        nvim_lua = "[Lua]",
                        path = "[Pth]",
                        calc = "[Clc]",
                        spell = "[Spl]",
                        emoji = "[Emj]",
                        treesitter = "[Trs]",
                    })[entry.source.name]

                    return vim_item
                end,
            },
        }

        require("cmp").setup(opts)
    end,
}
