local augroup = vim.api.nvim_create_augroup("entrypoint", { clear = true })

-- Enable the native LSP servers (lsp/*.lua) once the UI is up.
-- Diagnostic config lives in lua/config/diagnostics.lua.
vim.api.nvim_create_autocmd({ "VimEnter" }, {
	group = augroup,
	callback = function()
		vim.cmd("LspEnable")
	end,
})
