-- Single source of truth for diagnostics.
-- tiny-inline-diagnostic.nvim renders diagnostics inline, so Neovim's own
-- virtual_text is disabled here. Loaded from init.lua right after options.
vim.diagnostic.config({
	virtual_text = false,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		focusable = true,
		style = "minimal",
		border = "rounded",
		source = true,
		header = "",
		prefix = "",
		width = 60,
	},
	jump = {
		float = true,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = " ",
			[vim.diagnostic.severity.HINT] = "󰌵 ",
		},
	},
})
