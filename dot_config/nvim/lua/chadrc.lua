local M = {}

M.base46 = {
	theme = "catppuccin", -- default theme
	transparency = true,
	hl_override = {
		NormalFloat = { bg = "NONE", fg = "NONE" },
		FloatBorder = { bg = "NONE", fg = "#875fff" },
		FloatTitle = { fg = "#ffffff", bg = "#875fff" },
		Pmenu = { bg = "NONE", fg = "#875fff" },
		BlinkCmpMenuBorder = { bg = "NONE", fg = "#875fff" },
		BlinkCmpDocBorder = { bg = "NONE", fg = "#875fff" },
		BlinkCmpSignatureHelpBorder = { bg = "NONE", fg = "#875fff" },
		LazyBorder = { fg = "#875fff" },
		LazyNormal = { link = "Normal" },
		StatusLine = { bg = "NONE", fg = "#875fff" },
		StatusLineNC = { bg = "#16161e", fg = "#875fff" },
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
	cmp = {
		lspkind_text = true,
		style = "atom_colored", -- default/flat_light/flat_dark/atom/atom_colored

		format_colors = {
			tailwind = true,
			lsp = true,
		},
	},
}

return M
