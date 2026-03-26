vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.mouse = "a"

opt.number = true
opt.relativenumber = true

opt.clipboard = "unnamedplus"

opt.undofile = true

opt.ignorecase = true
opt.smartcase = true

opt.signcolumn = "yes"

opt.updatetime = 250
opt.timeoutlen = 300

opt.splitright = true
opt.splitbelow = true

opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

opt.inccommand = "split"

opt.cursorline = true

opt.scrolloff = 7

vim.g.have_nerd_font = true

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
