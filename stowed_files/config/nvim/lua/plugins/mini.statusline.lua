return {
	"echasnovski/mini.statusline",
	config = function()
		require("mini.statusline").setup({ use_icons = vim.g.have_nerd_font })
	end,
	version = false,
}
