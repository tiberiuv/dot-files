local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col(".") - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

local luasnip = require("luasnip")
local cmp = require "cmp"

-- vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
-- vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
-- vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
-- vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
-- vim.api.nvim_set_keymap("i", "<CR>", [[compe#confirm('<CR>')]], {expr = true})
-- vim.api.nvim_set_keymap("i", "<C-e>", [[compe#close('<C-e>')]], {expr = true})
-- vim.api.nvim_set_keymap("i", "<C-Space>", [[compe#complete()]], {expr = true})

local mapping = {
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<Tab>"] = cmp.mapping(
        function(fallback)
            if vim.fn.pumvisible() == 1 then
                --[[ elseif vim.fn["UltiSnips#CanExpandSnippet"]() == 1 or vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                 vim.fn.feedkeys(vim.fn.feedkeys(t "<C-R>=UltiSnips#ExpandSnippetOrJump()<CR>")) ]]
                vim.fn.feedkeys(t "<C-n>", "n")
            elseif luasnip.expand_or_jumpable() then
                --[[ elseif check_back_space() then
                 vim.fn.feedkeys(t "<Tab>") ]]
                vim.fn.feedkeys(t("<Plug>luasnip-expand-or-jump"), "")
            else
                fallback()
            end
        end,
        {
            "i",
            "s"
        }
    ),
    ["<S-Tab>"] = cmp.mapping(
        function(fallback)
            if vim.fn.pumvisible() == 1 then
                --[[ elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                vim.fn.feedkeys(t "<C-R>=UltiSnips#JumpBackwards()<CR>") ]]
                vim.fn.feedkeys(t "<C-p>", "n")
            elseif luasnip.jumpable(-1) then
                vim.fn.feedkeys(t("<Plug>luasnip-jump-prev"), "")
            else
                fallback()
            end
        end,
        {
            "i",
            "s"
        }
    )
}

cmp.setup {
    mapping = mapping,
    completion = {
        completeopt = "menu,menuone,noselect"
    },
    sources = {
        {name = "nvim_lsp"}
    },
    snippet = {
        expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
    },
    formatting = {
		format = function(entry, vim_item)
			-- vim_item.kind = string.format("%s %s", get_kind(vim_item.kind), vim_item.kind)
			vim_item.menu = ({
				nvim_lsp = "[LSP]",
				luasnip = "[Snp]",
				buffer = "[Buf]",
				nvim_lua = "[Lua]",
				path = "[Pth]",
				calc = "[Clc]",
				spell = "[Spl]",
				emoji = "[Emj]",
			})[entry.source.name]

			return vim_item
		end,
	}
}
