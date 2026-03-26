vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = "a"

vim.opt.showmode = false

vim.schedule(function()
    vim.opt.clipboard = "unnamedplus"
end)

vim.opt.breakindent = true

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes"

vim.opt.updatetime = 250

vim.opt.swapfile = false

vim.opt.timeoutlen = 150

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.inccommand = "split"

vim.opt.cursorline = true

vim.opt.scrolloff = 7

vim.opt.termguicolors = true

vim.diagnostic.config({
    virtual_text = {
        enabled = true,
        severity = {
            max = vim.diagnostic.severity.WARN,
        },
    },
    virtual_lines = {
        enabled = true,
        severity = {
            min = vim.diagnostic.severity.ERROR,
        },
    },
    update_in_insert = false,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

local keymap = vim.keymap

keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete Buffer" })
keymap.set("n", "<leader>bo", "<cmd>%bdelete|edit#<cr>", { desc = "Delete Other Buffers" })

keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.lsp.enable("lua_ls")
vim.lsp.enable("elixirls")
vim.lsp.enable("marksman")
vim.lsp.enable("nixd")
vim.lsp.enable("svelte")
vim.lsp.enable("yamlls")
vim.lsp.enable("jsonls")
vim.lsp.enable("terraformls")

local vue_language_server_path = vim.fs.dirname(vim.fn.exepath("vue-language-server"))
    .. "/../lib/language-tools/packages/language-server/node_modules/@vue/typescript-plugin"
local vue_plugin = {
    name = "@vue/typescript-plugin",
    location = vue_language_server_path,
    languages = { "vue" },
    configNamespace = "typescript",
    enableForWorkspaceTypeScriptVersions = true,
}

vim.lsp.config("vtsls", {
    settings = {
        vtsls = {
            tsserver = {
                globalPlugins = {
                    vue_plugin,
                },
            },
        },
    },
    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
})

vim.lsp.config("vue_ls", {})

vim.lsp.enable({ "vtsls", "vue_ls" })
