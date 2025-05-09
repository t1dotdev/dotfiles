local options = {}
vim.keymap.set("n", "<leader>fm", function()
	local conform = require("conform")
	conform.format({ quiet = true, async = true, lsp_format = false })
end, { desc = "[F]or[M]at" })

return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	opts = {
		formatters_by_ft = {
			css = { "prettier" },
			html = { "prettier" },
			python = { "black" },
			lua = { "stylua" },
			javascript = { "prettier" },
			typescript = { "prettier" },
		},
		format_on_save = {
			-- These options will be passed to conform.format()
			timeout_ms = 500,
			lsp_fallback = true,
			quiet = true,
		},
	},
}
