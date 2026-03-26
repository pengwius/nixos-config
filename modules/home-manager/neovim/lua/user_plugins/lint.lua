return {
    "nvim-lint",
    event = { "BufWritePost", "BufReadPost", "InsertLeave" },
    after = function()
        local lint = require("lint")

        lint.linters_by_ft = {}
    end,
}
