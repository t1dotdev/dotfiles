-- vim.g.mapleader = " "
-- vim.g.maplocalleader = "\\"

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Tabs & indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Appearance
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.cursorline = true

-- Backspace
vim.opt.backspace = "indent,eol,start"

-- Clipboard
vim.opt.clipboard:append("unnamedplus")

-- Split windows
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Consider - as part of word
vim.opt.iskeyword:append("-")

-- Disable swapfile
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- Undo
vim.opt.undofile = true
vim.opt.undolevels = 10000

-- Better completion experience
vim.opt.completeopt = "menu,menuone,noselect"

-- Time in milliseconds to wait for a mapped sequence
vim.opt.timeoutlen = 300

-- Enable mouse support
vim.opt.mouse = "a"

-- Hide mode since we have a statusline
vim.opt.showmode = false

-- Keep cursor away from screen edges
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Faster completion
vim.opt.updatetime = 250

-- Hide tabline
vim.opt.showtabline = 0

-- Command line height
vim.opt.cmdheight = 1

-- Confirm to save changes before exiting modified buffer
vim.opt.confirm = true

-- Splits
vim.opt.splitkeep = "screen"

-- Fold settings
vim.opt.foldlevel = 99
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- Session options
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- Disable some builtin providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0


