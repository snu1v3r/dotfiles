return {
	"folke/todo-comments.nvim",
	event = "VimEnter",
	dependencies = { "nvim-lua/plenary.nvim", "ibhagwan/fzf-lua" },
	opts = { signs = true, comments_only = true },
	optional = true,
}
