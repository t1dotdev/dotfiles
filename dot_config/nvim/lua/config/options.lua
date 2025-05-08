-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.snacks_animate = false
vim.g.ai_cmp = false

vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE", fg = "#875fff" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE", fg = "#875fff" })
vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE", fg = "#875fff" })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#875fff", fg = "#16161e" })
vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#875fff" })
vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", { bg = "NONE", fg = "#875fff" })
vim.api.nvim_set_hl(0, "BlinkCmpLabelDescription", { bg = "NONE", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE", ctermbg = "NONE" })
