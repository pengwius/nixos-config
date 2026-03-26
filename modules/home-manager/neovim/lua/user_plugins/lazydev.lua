return {
    "lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    after = function()
        require("lazydev").setup({

            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                { path = "snacks.nvim",        words = { "Snacks" } },
            },
        })
    end,
}
