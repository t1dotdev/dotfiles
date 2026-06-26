local M = {}

M.base46 = {
	theme = "catppuccin", -- default theme
	transparency = true,
	hl_override = {
		NormalFloat = { bg = "NONE", fg = "NONE" },
		FloatBorder = { bg = "NONE", fg = "#7A6FF0" },
		FloatTitle = { fg = "#ffffff", bg = "#7A6FF0" },
		Pmenu = { bg = "NONE", fg = "#7A6FF0" },
		BlinkCmpMenuBorder = { bg = "NONE", fg = "#7A6FF0" },
		BlinkCmpDocBorder = { bg = "NONE", fg = "#7A6FF0" },
		BlinkCmpSignatureHelpBorder = { bg = "NONE", fg = "#7A6FF0" },
		LazyBorder = { fg = "#7A6FF0" },
		LazyNormal = { link = "Normal" },
		StatusLine = { bg = "NONE", fg = "#7A6FF0" },
		StatusLineNC = { bg = "#16161e", fg = "#7A6FF0" },
	},
}

M.ui = {
	tabufline = {
		enabled = false,
	},
	statusline = {
		enabled = true,
		theme = "minimal",
	},
}

return M
