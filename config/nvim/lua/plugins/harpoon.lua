return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	opts = {},
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")
		harpoon.setup({})
		vim.keymap.set("n", "<leader>ha", function()
			harpoon:list():add()
		end, { desc = "[A]dd location to Harpoon" })

		vim.keymap.set("n", "<M-e>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end)
		vim.keymap.set("n", "<M-h>", function()
			harpoon:list():select(1)
		end)
		vim.keymap.set("n", "<M-t>", function()
			harpoon:list():select(2)
		end)
		vim.keymap.set("n", "<M-n>", function()
			harpoon:list():select(3)
		end)
		vim.keymap.set("n", "<M-s>", function()
			harpoon:list():select(4)
		end)
	end,
}
