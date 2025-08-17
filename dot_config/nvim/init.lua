-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE", fg = "NONE" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE", fg = "#875fff" })
vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE", fg = "#875fff" })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#875fff", fg = "#16161e" })
vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#875fff" })

vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", { bg = "NONE", fg = "#875fff" })
vim.api.nvim_set_hl(0, "BlinkCmpLabelDescription", { bg = "NONE", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE", ctermbg = "NONE" })

vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE", fg = "#888888" })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE", fg = "#ffffff" })

-- vim.cmd("highlight Visual guifg=#ffffff guibg=#875fff")
