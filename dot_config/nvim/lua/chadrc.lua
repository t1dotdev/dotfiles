local M = {}

M.base46 = {
	theme = "catppuccin", -- default theme
	transparency = true,
	hl_override = {
		St_NormalMode = { bg = "#875fff", fg = "#171928" },
		St_NormalModeSep = { fg = "#875fff", bg = "#171928" },
		St_NormalmodeText = { fg = "#875fff", bg = "#292D48" },
		NormalFloat = { bg = "NONE", fg = "NONE" },
		FloatBorder = { bg = "NONE", fg = "#875fff" },
		FloatTitle = { fg = "#ffffff", bg = "#875fff" },
		Pmenu = { bg = "NONE", fg = "#875fff" },
		BlinkCmpMenuBorder = { bg = "NONE", fg = "#875fff" },
		BlinkCmpDocBorder = { bg = "NONE", fg = "#875fff" },
		BlinkCmpSignatureHelpBorder = { bg = "NONE", fg = "#875fff" },
		LazyBorder = { fg = "#875fff" },
		LazyNormal = { link = "Normal" },

		--     vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE", fg = "#875fff" })
		-- vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#875fff", fg = "#16161e" })
		-- vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#875fff" })
		--
		-- vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", { bg = "NONE", fg = "#875fff" })
		-- vim.api.nvim_set_hl(0, "BlinkCmpLabelDescription", { bg = "NONE", fg = "#ffffff" })
		-- vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE", ctermbg = "NONE" })
	},
}

M.ui = {
	tabufline = {
		enabled = false,
	},
	statusline = {
		enabled = false,
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

M.nvdash = {
	load_on_startup = false,
	header = {
		"                            ",
		"     ▄▄         ▄ ▄▄▄▄▄▄▄   ",
		"   ▄▀███▄     ▄██ █████▀    ",
		"   ██▄▀███▄   ███           ",
		"   ███  ▀███▄ ███           ",
		"   ███    ▀██ ███           ",
		"   ███      ▀ ███           ",
		"   ▀██ █████▄▀█▀▄██████▄    ",
		"     ▀ ▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀   ",
		"                            ",
		"     Powered By  eovim    ",
		"                            ",
	},

	buttons = {
		{ txt = "  Find File", keys = "Spc f f", cmd = "Telescope find_files" },
		{ txt = "  Recent Files", keys = "Spc f o", cmd = "Telescope oldfiles" },
		-- more... check nvconfig.lua file for full list of buttons
	},
}

return M
