local border = {
	{ "╭", "FloatBorderLsp" },
	{ "─", "FloatBorderLsp" },
	{ "╮", "FloatBorderLsp" },
	{ "│", "FloatBorderLsp" },
	{ "╯", "FloatBorderLsp" },
	{ "─", "FloatBorderLsp" },
	{ "╰", "FloatBorderLsp" },
	{ "│", "FloatBorderLsp" },
}

local handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
}

local capabilities_opt = {
	textDocument = {
		foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		},
	},
}
local function _config()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities =
		vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities(capabilities_opt))
	-- capabilities = vim.tbl_deep_extend('force', capabilities,
	-- require('cmp_nvim_lsp').default_capabilities()
	-- )

	local servers = {
		-- clangd = {},
		-- zls = {},
		yamlls = {},
		html = {},
		pyright = {},
		ts_ls = {},
		cssls = {
			settings = {
				css = {
					lint = {
						unknownAtRules = "ignore",
					},
				},
			},
		},
		tailwindcss = {},
		svelte = {},
		emmet_ls = {
			-- filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "svelte", "pug", "typescriptreact", "vue" },
		},
		lua_ls = {},
		eslint_d = {
			root_dir = require("lspconfig").util.root_pattern(
				".eslintrc",
				".eslintrc.js",
				".eslintrc.cjs",
				".eslintrc.yaml",
				".eslintrc.yml",
				".eslintrc.json",
				"eslint.config.js",
				"eslint.config.mjs",
				"eslint.config.cjs",
				"eslint.config.ts",
				"eslint.config.mts",
				"eslint.config.cts"
			),
		},
		-- rust_analyzer = {},
	}
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
		callback = function(event)
			local map = function(keys, func, desc, mode)
				mode = mode or "n"
				vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
			end

			-- map('gd', require('telescope.builtin').lsp_definitions,
			--     '[G]oto [D]efinition')
			-- map('gr', require('telescope.builtin').lsp_references,
			--     '[G]oto [R]eferences')
			-- map('gI', require('telescope.builtin').lsp_implementations,
			--     '[G]oto [I]mplementation')
			-- map('<leader>D', require('telescope.builtin').lsp_type_definitions,
			--     'Type [D]efinition')
			-- map('<leader>ds', require('telescope.builtin').lsp_document_symbols,
			--     '[D]ocument [S]ymbols')
			-- map('<leader>ws',
			--     require('telescope.builtin').lsp_dynamic_workspace_symbols,
			--     '[W]orkspace [S]ymbols')
			--
			map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

			-- map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
			map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
			map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
				local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					buffer = event.buf,
					group = highlight_augroup,
					callback = vim.lsp.buf.document_highlight,
				})

				vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					buffer = event.buf,
					group = highlight_augroup,
					callback = vim.lsp.buf.clear_references,
				})

				vim.api.nvim_create_autocmd("LspDetach", {
					group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
					callback = function(event2)
						vim.lsp.buf.clear_references()
						vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
					end,
				})
			end
		end,
	})

	local ensure_installed = vim.tbl_keys(servers or {})
	vim.list_extend(ensure_installed, {
		"stylua",
		"jsonlint",
		"prettier",
		"black",
		"pylint",
		"eslint_d",
		-- 'markdownlint',
	})

	require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
	require("mason-lspconfig").setup({
		handlers = {
			function(server_name)
				local server = servers[server_name] or {}
				server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
				server.handlers = handlers
				require("lspconfig")[server_name].setup(server)
			end,
		},
	})
end

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", opts = {} },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"saghen/blink.cmp",
		-- 'hrsh7th/cmp-nvim-lsp',
	},
	config = _config,
}
