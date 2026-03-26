return {
    {
        "conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo", "Format" },
        keys = {
            {
                "<leader>cF",
                function()
                    require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
                end,
                mode = { "n", "v" },
                desc = "Format Injected Langs",
            },
        },
        after = function()
            local conform = require("conform")

            conform.setup({
                default_format_opts = {
                    timeout_ms = 2000,
                    async = false,
                    quiet = false,
                    lsp_format = "fallback",
                },
                format_on_save = {
                    timeout_ms = 500,
                    async = false,
                    lsp_format = "fallback",
                },

                formatters_by_ft = {
                    lua = { "stylua" },
                    sh = { "shfmt" },
                    rust = { "rustfmt", lsp_format = "fallback" },
                    typescript = { "prettierd", "prettier" },
                    javascript = { "prettierd", "prettier", stop_after_first = true },
                    astro = { "prettier" },
                    markdown = { "prettierd" },
                    nix = { "nixfmt" },
                    svelte = { "prettier" },
                },
            })
        end,
    },
}
