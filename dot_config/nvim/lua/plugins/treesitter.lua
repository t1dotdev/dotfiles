return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "html", "javascript", "typescript", "tsx", "xml" },
			auto_install = true,
			highlight = { enable = true },
		})
	end,
}
