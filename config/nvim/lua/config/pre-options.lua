-- Additional options for nvim
vim.opt.shada = "'50,<1000,s100,:0"

-- Enable line numbers and relative numbers
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.numberwidth = 4

-- Convert tabs to spaces and improve tab behaviour
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.shiftwidth = 4 -- Amount to indent with << and >>
vim.opt.tabstop = 4 -- How many spaces are shown per Tab
vim.opt.softtabstop = 4 -- How many spaces are applied when pressing Tab

vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.autoindent = true -- Keep identation from previous line
vim.opt.breakindent = true

-- Store undos between sessions
vim.opt.undofile = true

-- Searches case insensitve unless a uppercase is used in the searchterm
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

vim.opt.incsearch = true
vim.opt.scrolloff = 8
vim.g.have_nerd_font = true
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.splitright = true
