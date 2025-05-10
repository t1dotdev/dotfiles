local options = {
	ensure_installed = {
		"bash",
		"regex",
		"c",
		"markdown",
		"markdown_inline",
		"query",
		"sql",
		"gitignore",
		"vim",
		"lua",
		"vimdoc",
		"html",
		"css",
		"javascript",
		"typescript",
		"java",
		"svelte",
		"python",
		"zig",
		"go",
		"json",
	},
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = { "ruby", "cfg" },
	},
	indent = { enable = true, disable = { "ruby" } },
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPre", "BufNewFile" },
		main = "nvim-treesitter.configs",
		opts = options,
	},
}
