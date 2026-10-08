-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/rust_analyzer.lua
-- rust-analyzer finds the enclosing Cargo workspace itself from the crate root.
return {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", "rust-project.json", ".git" },
}
