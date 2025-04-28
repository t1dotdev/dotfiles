vim.keymap.set({ "n", "v" }, "<leader>aa", ":CodeCompanionAction<CR>", { desc = "[A]i [A]ction" })
vim.keymap.set("v", "<leader>ae", ":CodeCompanion<CR>", { desc = "[A]i [E]dit" })

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
									default = "gemini-2.0-flash-001",
								},
							},
						})
					end,
				},
			})
		end,
	},
}
