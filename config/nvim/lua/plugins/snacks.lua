return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		bigfile = { enabled = true },
		dashboard = { enabled = true },
		explorer = { enabled = true },
		indent = { enabled = true },
		input = { enabled = true },
		picker = { enabled = true },
		notifier = { enabled = true },
		quickfile = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = true },
		lazygit = { enabled = true },
		-- statuscolumn = { enabled = true },
		words = { enabled = true },
		terminal = { enabled = false },
	},
	keys = {
		{
			"<leader>xf",
			function()
				Snacks.picker.explorer()
			end,
			desc = "E[x]plorer [f]iles",
		},
		{
			"<leader>xc",
			function()
				Snacks.dashboard.pick("files", { cwd = vim.fn.stdpath("config") })
				-- Snacks.picker.explorer()
			end,
			desc = "E[x]plore [c]onfiguration",
		},
		{
			"<C-\\>",
			function()
				Snacks.terminal.toggle()
			end,
			desc = "Toggle Terminal",
		},
	},
}
