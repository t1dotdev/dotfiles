vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46_cache/"

-- Load options first
require("config.options")

require("config.lazy")
require("config.keymaps")
for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
	dofile(vim.g.base46_cache .. v)
end

vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE", fg = "NONE" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE", fg = "#875fff" })
vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE", fg = "#875fff" })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#875fff", fg = "#16161e" })
vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#875fff" })

vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", { bg = "NONE", fg = "#875fff" })
vim.api.nvim_set_hl(0, "BlinkCmpLabelDescription", { bg = "NONE", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE", ctermbg = "NONE" })

-- vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE", fg = "#888888" })
-- vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE", fg = "#ffffff" })
