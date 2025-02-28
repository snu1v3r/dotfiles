return {
	"TobinPalmer/pastify.nvim",
	cmd = { "Pastify", "PastifyAfter" },
	event = { "BufReadPost" }, -- Load after the buffer is read, I like to be able to paste right away
	keys = {
		{ noremap = true, mode = "n", "<leader>pa", "<cmd>PastifyAfter<CR>", { desc = "[P]astify [A]fter" } },
		{
			noremap = true,
			mode = "n",
			"<leader>ph",
			function()
				vim.cmd.Pastify()
				-- Get the commands module from neo-tree.sources.filesystem. Found here: https://github.com/nvim-neo-tree/neo-tree.nvim/blob/main/lua/neo-tree/sources/filesystem/commands.lua
				require("neo-tree.sources.filesystem.commands")
					-- Call the refresh function found here: https://github.com/nvim-neo-tree/neo-tree.nvim/blob/2f2d08894bbc679d4d181604c16bb7079f646384/lua/neo-tree/sources/filesystem/commands.lua#L11-L13
					.refresh(
						-- Pull in the manager module. Found here: https://github.com/nvim-neo-tree/neo-tree.nvim/blob/2f2d08894bbc679d4d181604c16bb7079f646384/lua/neo-tree/sources/manager.lua
						require("neo-tree.sources.manager")
							-- Fetch the state of the "filesystem" source, feeding it to the filesystem refresh call since most everything in neo-tree
							-- expects to get its state fed to it
							.get_state("filesystem")
					)
			end,
			{ desc = "[P]astify [H]ere" },
		},
	},
	config = function()
		require("pastify").setup({
			opts = {
				absolute_path = false, -- use absolute or relative path to the working directory
				apikey = "", -- Api key, required for online saving
				local_path = "/screenshots/", -- The path to put local files in, ex ~/Projects/<name>/assets/images/<imgname>.png
				save = "local", -- Either 'local' or 'online' or 'local_file'
				filename = "",
				default_ft = "markdown", -- Default filetype to use
			},
			ft = { -- Custom snippets for different filetypes, will replace $IMG$ with the image url
				html = '<img src="$IMG$" alt="">',
				markdown = "![]($IMG$)",
				tex = [[\includegraphics[width=\linewidth]{$IMG$}]],
				css = 'background-image: url("$IMG$");',
				js = 'const img = new Image(); img.src = "$IMG$";',
				xml = '<image src="$IMG$" />',
				php = '<?php echo "<img src="$IMG$" alt="">"; ?>',
				python = "# $IMG$",
				java = "// $IMG$",
				c = "// $IMG$",
				cpp = "// $IMG$",
				swift = "// $IMG$",
				kotlin = "// $IMG$",
				go = "// $IMG$",
				typescript = "// $IMG$",
				ruby = "# $IMG$",
				vhdl = "-- $IMG$",
				verilog = "// $IMG$",
				systemverilog = "// $IMG$",
				lua = "-- $IMG$",
			},
		})
	end,
}
