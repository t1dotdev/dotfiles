vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.laststatus = 3

vim.g.snacks_animate = false

local opt = vim.opt

opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
opt.number = true -- Print line number
opt.wrap = false -- Disable line wrap
opt.tabstop = 4 -- Number of spaces tabs count for
opt.shiftwidth = 4 -- Size of an indent
opt.expandtab = false -- Converts tabs to spaces
opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}
