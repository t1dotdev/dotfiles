-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/css_variables.lua
return {
	cmd = { "css-variables-language-server", "--stdio" },
	filetypes = { "css", "scss", "less" },
	root_markers = { "package.json", ".git" },
	settings = {
		cssVariables = {
			lookupFiles = { "**/*.less", "**/*.scss", "**/*.sass", "**/*.css" },
			blacklistFolders = { "**/.cache", "**/.git", "**/dist", "**/node_modules", "**/build" },
		},
	},
}
