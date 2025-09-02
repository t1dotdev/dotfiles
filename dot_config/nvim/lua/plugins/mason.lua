-- lua/plugins/mason.lua
return {
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		opts = {
			ui = {
				border = "rounded",
			},
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
		opts = {
			ensure_installed = {
				"ts_ls",
				"tailwindcss",
				"eslint",
				"cssls",
				"html",
				"jsonls",
				"prismals",
				"lua_ls",
				"pyright",
				"gopls",
				"rust_analyzer",
				"dockerls",
				"yamlls",
				"bashls",
				"vimls",
				"clangd",
			},
			automatic_installation = true,
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				"prettier",
				"eslint_d",
				"stylua",
				"black",
				"isort",
				"goimports",
				"gofumpt",
				"shfmt",
				"rustfmt",
			},
		},
	},
}
