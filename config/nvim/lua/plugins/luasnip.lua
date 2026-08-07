return {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    -- load snippets from path/of/your/nvim/config/my-cool-snippets
    dependencies = {
        "rafamadriz/friendly-snippets",
        config = function()
            -- 1. Load friendly-snippets (default VS Code format)
            require("luasnip.loaders.from_vscode").lazy_load()

            -- 2. Load custom snippets from your specified path
            require("luasnip.loaders.from_vscode").lazy_load({
                paths = { vim.fn.stdpath("config") .. "/snippets" }
            })
        end,
    },
}
