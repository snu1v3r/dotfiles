return {
	"mikavilpas/yazi.nvim",
	event = "VeryLazy",
	dependencies = { "folke/snacks.nvim", lazy = true },
	keys = {
		{
			"<leader>yz",
			mode = { "n", "v" },
			"<cmd>Yazi<cr>",
			desc = "Open [Y]a[z]i at the current file",
		},
		{
			"<leader>yw",
			mode = { "n", "v" },
			"<cmd>Yazi cwd<cr>",
			desc = "Open [Y]azi in the current [w]orking directory",
		},
		{
			"<c-up>",
			mode = { "n", "v", "t" },
			"<cmd>Yazi toggle<cr>",
			desc = "Toggle Yazi",
		},
	},
	---@type YaziConfig | {}
	opts = {
		-- if you want to open yazi instead of netrw, see below for more info
		open_for_directories = true,
		keymaps = {
			help = "<f1>",
		},
	},
	-- 👇 if you use `open_for_directories=true`, this is recommended
	init = function()
		-- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
		-- vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1
	end,
}
