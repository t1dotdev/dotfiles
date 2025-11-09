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
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				"vtsls",
				"tailwindcss",
				"eslint",
				"cssls",
				"html",
				"jsonls",
				"lua_ls",
				"pyright",
				"yamlls",
				"bashls",
			},
			automatic_installation = true,
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {
				"prettier",
				"eslint_d",
				"stylua",
				"shfmt",
			}
			table.insert(opts.ensure_installed, "js-debug-adapter")
			return opts
		end,
	},
}
