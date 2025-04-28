vim.keymap.set({ "n", "v", "x" }, "<leader>aa", "<cmd>CodeCompanionAction<CR>", { desc = "[A]i [A]ction" })

return {
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("codecompanion").setup({
				adapters = {
					copilot = function()
						return require("codecompanion.adapters").extend("copilot", {
							schema = {
								model = {
									default = "gpt-4o-mini",
								},
							},
						})
					end,
				},
			})
		end,
	},
}
