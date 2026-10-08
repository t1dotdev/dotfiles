-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/emmet_language_server.lua
return {
	cmd = { "emmet-language-server", "--stdio" },
	filetypes = { "css", "html", "javascriptreact", "less", "sass", "scss", "svelte", "typescriptreact" },
	root_markers = { ".git" },
}
