-- Additional options for nvim
vim.opt.shada = "'50,<1000,s100,:0"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.incsearch = true
vim.opt.scrolloff = 8

vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>", { desc = "[U]ndotree Toggle" })
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "[B]uffer [N]ext" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "[B]uffer [P]revious" })
vim.keymap.set("n", "<leader>bl", ":ls<CR>", { desc = "[B]uffer [L]ist" })
vim.keymap.set("n", "<leader>xf", vim.cmd.Ex, { desc = "E[x]plore [f]ile" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected block down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move selected block up" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "join lines without moving the cursor" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Jump to next occurence with search in the middle" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Jump to next occurence with search in the middle" })

vim.keymap.set("x", "<leader>pp", '"_dP', { desc = "[P]aste over without replacing register" })

vim.keymap.set({ "n", "v" }, "<leader>yz", "<cmd>Yazi<cr>", { desc = "Open [Y]a[z]i at the current file" })
vim.keymap.set(
	{ "n", "v" },
	"<leader>yw",
	"<cmd>Yazi cwd<cr>",
	{ desc = "Open [Y]azi in the current [w]orking directory" }
)
vim.keymap.set({ "n", "v", "t" }, "<c-up>", "<cmd>Yazi toggle<cr>", { desc = "Toggle Yazi" })

local harpoon = require("harpoon")
harpoon.setup({})
vim.keymap.set("n", "<leader>a", function()
	harpoon:list():add()
end, { desc = "[A]dd location to Harpoon" })

vim.keymap.set("n", "<C-e>", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end)
vim.keymap.set("n", "<C-h>", function()
	harpoon:list():select(1)
end)
vim.keymap.set("n", "<C-t>", function()
	harpoon:list():select(2)
end)
vim.keymap.set("n", "<C-n>", function()
	harpoon:list():select(3)
end)
vim.keymap.set("n", "<C-s>", function()
	harpoon:list():select(4)
end)
return {}
