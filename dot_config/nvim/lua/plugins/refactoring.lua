return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	keys = {
		{
			"<leader>re",
			function()
				require("refactoring").refactor("Extract Function")
			end,
			mode = "x",
			desc = "Extract Function",
		},
		{
			"<leader>rf",
			function()
				require("refactoring").refactor("Extract Function To File")
			end,
			mode = "x",
			desc = "Extract Function To File",
		},
		{
			"<leader>rv",
			function()
				require("refactoring").refactor("Extract Variable")
			end,
			mode = "x",
			desc = "Extract Variable",
		},
		{
			"<leader>ri",
			function()
				require("refactoring").refactor("Inline Variable")
			end,
			mode = { "n", "x" },
			desc = "Inline Variable",
		},
	},
	opts = {},
}
