return
{
    "nvim-treesitter/nvim-treesitter",
    opts = {
        ensure_installed = { "markdown", "markdown_inline", "python", "dockerfile", "bash", "javascript", "php", "ansible" },
        highlight = {
            enable = true,
            -- Fallback to vim regex if treesitter fails for some elements
            additional_vim_regex_highlighting = { "markdown" },
        },
    },
}
