local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local cmp_kinds = {
    Field = {icon = "ﰠ", order = 11},
    Property = {icon = "ﰠ", order = 11},
    Constant = {icon = "", order = 10},
    Enum = {icon = "", order = 10},
    EnumMember = {icon = "", order = 10},
    Event = {icon = "", order = 10},
    Function = {icon = "", order = 10},
    Method = {icon = "", order = 10},
    Operator = {icon = "", order = 10},
    Reference = {icon = "", order = 10},
    Struct = {icon = "פּ", order = 10},
    Variable = {icon = "", order = 9},
    File = {icon = "", order = 8},
    Folder = {icon = "", order = 8},
    Class = {icon = "ﴯ", order = 5},
    Color = {icon = "", order = 5},
    Module = {icon = "", order = 5},
    Keyword = {icon = "", order = 2},
    Constructor = {icon = "", order = 1},
    Interface = {icon = "", order = 1},
    Text = {icon = "", order = 1},
    Unit = {icon = "塞", order = 1},
    Value = {icon = "", order = 1},
    TypeParameter = {icon = "", order = 1},
    Snippet = {icon = "", order = 0}
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

local luasnip = require("luasnip")
local cmp = require "cmp"

local tab = function(fallback)
    if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(t "<C-n>", "n")
    elseif luasnip.expand_or_jumpable() then
        vim.fn.feedkeys(t("<Plug>luasnip-expand-or-jump"), "")
    else
        fallback()
    end
end

local stab = function(fallback)
    if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(t "<C-p>", "n")
    elseif luasnip.jumpable(-1) then
        vim.fn.feedkeys(t("<Plug>luasnip-jump-prev"), "")
    else
        fallback()
    end
end

local mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm(),
    ["<Tab>"] = cmp.mapping(tab, {"i", "s"}),
    ["<S-Tab>"] = cmp.mapping(stab, {"i", "s"})
}

cmp.setup {
    mapping = mapping,
    completion = {
        completeopt = "menu,menuone,noselect",
        keyword_length = 2
    },
    sources = {
        {name = "nvim_lsp"},
        {name = "luasnip"},
        {name = "path"}
    },
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end
    },
    formatting = {
        format = function(entry, vim_item)
            vim_item.kind = cmp_kinds[vim_item.kind].icon .. " " .. vim_item.kind
            vim_item.menu =
                ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snp]",
                buffer = "[Buf]",
                nvim_lua = "[Lua]",
                path = "[Pth]",
                calc = "[Clc]",
                spell = "[Spl]",
                emoji = "[Emj]",
                treesitter = "[Trs]"
            })[entry.source.name]

            return vim_item
        end
    },
    sorting = {
        comparators = {
            lspkind_comparator(cmp_kinds),
            label_comparator
        }
    }
}
