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

-- vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
-- vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
-- vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
-- vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "-", "<cmd>Oil --float<CR>", { desc = "Oil as a floating window" })
local snacks = require("snacks")
vim.keymap.set("n", "<leader>sh", snacks.picker.help, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sk", snacks.picker.keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sf", snacks.picker.files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sc", function()
	snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[S]earch [C]onfig files" })
vim.keymap.set("n", "<leader>sb", snacks.picker.commands, { desc = "[S]earch [C]ommands" })
vim.keymap.set("n", "<leader>st", snacks.picker.treesitter, { desc = "[S]earch [T]reesitter" })
vim.keymap.set("n", "<leader>su", snacks.picker.undo, { desc = "[S]earch [U]ndo" })
vim.keymap.set("n", "<leader>sw", snacks.picker.grep_word, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", snacks.picker.grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", snacks.picker.diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", snacks.picker.resume, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>s.", snacks.picker.recent, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set("n", "<leader><leader>", snacks.picker.buffers, { desc = "[ ] Find existing buffers" })

-- Slightly advanced example of overriding default behavior and theme
vim.keymap.set("n", "<leader>/", function()
	-- You can pass additional configuration to Telescope to change the theme, layout, etc.
	builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer" })

-- It's also possible to pass additional configuration options.
--  See `:help telescope.builtin.live_grep()` for information about particular keys
vim.keymap.set("n", "<leader>s/", function()
	builtin.live_grep({
		grep_open_files = true,
		prompt_title = "Live Grep in Open Files",
	})
end, { desc = "[S]earch [/] in Open Files" })

-- Shortcut for searching your Neovim configuration files
vim.keymap.set("n", "<leader>sn", function()
	snacks.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[S]earch [N]eovim files" })
