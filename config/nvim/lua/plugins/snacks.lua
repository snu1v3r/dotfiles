return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	dependencies = {
		"folke/todo-comments.nvim",
		config = function()
			require("todo-comments").setup({})
		end,
	},

	---@type snacks.Config
	dependencies = {
		"folke/todo-comments.nvim",
		config = function()
			require("todo-comments").setup({})
		end,
	},
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		bigfile = { enabled = true },
		dashboard = { enabled = true },
		explorer = { enabled = true },
		indent = { enabled = true },
		input = { enabled = true },
		picker = {
			enabled = true,
			sources = {
				todo_comments = { hidden = true }, -- Required if using hidden directories (e.g., stow symlinks)
			},
		},
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
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					-- NOTE: Remember that Lua is a real programming language, and as such it is possible
					-- to define small helper and utility functions so you don't have to repeat yourself.
					--
					-- In this case, we create a function that lets us more easily define mappings specific
					-- for LSP related items. It sets the mode, buffer and description for us each time.
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- Jump to the definition of the word under your cursor.
					--  This is where a variable was first declared, or where a function is defined, etc.
					--  To jump back, press <C-t>.
					-- map("gd", require("snacks").picker.lsp_definitions, "[G]oto [D]efinition")
					--
					-- -- Find references for the word under your cursor.
					-- map("gr", require("snacks").picker.lsp_references, "[G]oto [R]eferences")
					--
					-- -- Jump to the implementation of the word under your cursor.
					-- --  Useful when your language has ways of declaring types without an actual implementation.
					-- map("gI", require("snacks").picker.lsp_implementations, "[G]oto [I]mplementation")
					--
					-- -- Jump to the type of the word under your cursor.
					-- --  Useful when you're not sure what type a variable is and you want to see
					-- --  the definition of its *type*, not where it was *defined*.
					-- map("<leader>D", require("snacks").picker.lsp_type_definitions, "Type [D]efinition")
					--
					-- -- Fuzzy find all the symbols in your current document.
					-- --  Symbols are things like variables, functions, types, etc.
					-- map("<leader>ds", require("snacks").picker.lsp_symbols, "[D]ocument [S]ymbols")
					--
					-- -- Fuzzy find all the symbols in your current workspace.
					-- --  Similar to document symbols, except searches over your entire project.
					-- map("<leader>ws", require("snacks").picker.lsp_workspace_symbols, "[W]orkspace [S]ymbols")
				end,
			})
		end,
	},
}
