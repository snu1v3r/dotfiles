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
vim.keymap.set("n", "<leader>sC", snacks.picker.commands, { desc = "[S]earch [C]ommands" })
vim.keymap.set("n", "<leader>sT", snacks.picker.todo_comments, { desc = "[S]earch [T]odo-comments" })
vim.keymap.set("n", "<leader>st", snacks.picker.treesitter, { desc = "[S]earch [T]reesitter" })
vim.keymap.set("n", "<leader>su", snacks.picker.undo, { desc = "[S]earch [U]ndo" })
vim.keymap.set("n", "<leader>sw", snacks.picker.grep_word, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", snacks.picker.grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", snacks.picker.diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", snacks.picker.resume, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>s.", snacks.picker.recent, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set("n", "<leader><leader>", snacks.picker.buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>lg", snacks.lazygit.open, { desc = "[L]azy [G]it" })

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

-- Keymaps that are loaded when an LSP attaches

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
	callback = function(event)
		-- In this case, we create a function that lets us more easily define mappings specific
		-- for LSP related items. It sets the mode, buffer and description for us each time.
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		-- Jump to the definition of the word under your cursor.
		--  This is where a variable was first declared, or where a function is defined, etc.
		--  To jump back, press <C-t>.
		map("gd", require("snacks").picker.lsp_definitions, "[G]oto [D]efinition")

		-- Find references for the word under your cursor.
		map("gr", require("snacks").picker.lsp_references, "[G]oto [R]eferences")

		-- Jump to the implementation of the word under your cursor.
		--  Useful when your language has ways of declaring types without an actual implementation.
		map("gI", require("snacks").picker.lsp_implementations, "[G]oto [I]mplementation")

		-- Jump to the type of the word under your cursor.
		--  Useful when you're not sure what type a variable is and you want to see
		--  the definition of its *type*, not where it was *defined*.
		map("<leader>D", require("snacks").picker.lsp_type_definitions, "Type [D]efinition")

		-- Fuzzy find all the symbols in your current document.
		--  Symbols are things like variables, functions, types, etc.
		map("<leader>ds", require("snacks").picker.lsp_symbols, "[D]ocument [S]ymbols")

		-- Fuzzy find all the symbols in your current workspace.
		--  Similar to document symbols, except searches over your entire project.
		map("<leader>ws", require("snacks").picker.lsp_workspace_symbols, "[W]orkspace [S]ymbols")

		-- Rename the variable under your cursor.
		--  Most Language Servers support renaming across files, etc.
		map("<leader>cr", vim.lsp.buf.rename, "[R]e[n]ame")

		-- Execute a code action, usually your cursor needs to be on top of an error
		-- or a suggestion from your LSP for this to activate.
		map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

		-- WARN: This is not Goto Definition, this is Goto Declaration.
		--  For example, in C this would take you to the header.
		map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	end,
})
