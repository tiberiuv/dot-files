require("gitsigns").setup({
	sign_priority = 4,
	keymaps = {
		noremap = true,
		["n <leader>s"] = '<cmd>lua require"gitsigns".blame_line{full=true}<CR>',
	},
})
