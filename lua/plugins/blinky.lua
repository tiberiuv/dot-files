return {
	'saghen/blink.nvim',
	keys = {
		-- chartoggle
		{
			';',
			function()
				require('blink.chartoggle').toggle_char_eol(';')
			end,
			mode = { 'n', 'v' },
			desc = 'Toggle ; at eol',
		},
		{
			',',
			function()
				require('blink.chartoggle').toggle_char_eol(',')
			end,
			mode = { 'n', 'v' },
			desc = 'Toggle , at eol',
		},

		-- tree
		{ '<C-e>',     '<cmd>BlinkTree reveal<cr>',       desc = 'Reveal current file in tree' },
		{ '<leader>E', '<cmd>BlinkTree toggle<cr>',       desc = 'Reveal current file in tree' },
		{ '<leader>e', '<cmd>BlinkTree toggle-focus<cr>', desc = 'Toggle file tree focus' },
	},
	-- all modules handle lazy loading internally
	lazy = false,
	opts = {
		chartoggle = { enabled = true },
		delimiters = { enabled = true },
		-- indent = { enabled = true },
		-- tree = { enabled = true }
	},
	{
		'saghen/blink.cmp',
		-- optional: provides snippets for the snippet source
		dependencies = 'rafamadriz/friendly-snippets',

		version = "v0.8.2",

		opts = {
			keymap = {
				preset = 'enter',
				['<Tab>'] = {
					function(cmp)
						if cmp.snippet_active() then
							return cmp.accept()
						else
							return cmp.select_and_accept()
						end
					end,
					'snippet_forward',
					'fallback'
				},
				['<S-Tab>'] = { 'snippet_backward', 'fallback' },
			},

			appearance = {
				-- Sets the fallback highlight groups to nvim-cmp's highlight groups
				-- Useful for when your theme doesn't support blink.cmp
				-- Will be removed in a future release
				use_nvim_cmp_as_default = true,
				-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = 'mono'
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { 'lsp', 'path', 'snippets', 'buffer' },
			},
			completion = {
				list = { selection = function(ctx) return ctx.mode == 'cmdline' and 'auto_insert' or 'preselect' end },
				documentation = { auto_show = true, auto_show_delay_ms = 250 },
				menu = {
					draw = {
						columns = {
							{ "label",     "label_description", gap = 1 },
							{ "kind_icon", "kind" }
						},
					}

				}
			},
		},
		opts_extend = { "sources.default" },
	}
}
