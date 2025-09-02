return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"saghen/blink.cmp",
		"nvim-tree/nvim-web-devicons",
		"b0o/schemastore.nvim",
	},
	config = function()
		local lspconfig = require("lspconfig")

		-- LSP diagnostic signs
		local signs = {
			Error = " ",
			Warn = " ",
			Hint = " ",
			Info = " ",
		}

		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
		end

		-- Diagnostic configuration
		vim.diagnostic.config({
			virtual_text = {
				prefix = "�",
				source = "if_many",
			},
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})

		-- LSP handlers
		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
			border = "rounded",
		})

		vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
			border = "rounded",
		})

		-- LSP on_attach function
		local on_attach = function(client, bufnr)
			local opts = { noremap = true, silent = true, buffer = bufnr }

			-- LSP keymaps
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
			vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
			vim.keymap.set("n", "<leader>f", function()
				vim.lsp.buf.format({ async = true })
			end, opts)

			-- Diagnostic keymaps
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
			vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
			vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

			-- Enable inlay hints if available
			if client.server_capabilities.inlayHintProvider then
				vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			end

			-- Document highlighting
			if client.server_capabilities.documentHighlightProvider then
				vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
				vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_document_highlight" })
				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					group = "lsp_document_highlight",
					buffer = bufnr,
					callback = vim.lsp.buf.document_highlight,
				})
				vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					group = "lsp_document_highlight",
					buffer = bufnr,
					callback = vim.lsp.buf.clear_references,
				})
			end
		end

		-- Default capabilities with blink.cmp integration
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

		-- Server-specific configurations
		local servers = {
			-- Lua
			lua_ls = {
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = {
							enable = false,
						},
						hint = {
							enable = true,
						},
					},
				},
			},

			-- TypeScript/JavaScript
			ts_ls = {
				settings = {
					typescript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
					javascript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
				},
			},

			-- Python
			pyright = {
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "workspace",
							useLibraryCodeForTypes = true,
						},
					},
				},
			},

			-- Go
			gopls = {
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
						},
						staticcheck = true,
						gofumpt = true,
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							compositeLiteralTypes = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
					},
				},
			},

			-- Rust
			rust_analyzer = {
				settings = {
					["rust-analyzer"] = {
						assist = {
							importEnforceGranularity = true,
							importPrefix = "crate",
						},
						cargo = {
							allFeatures = true,
						},
						checkOnSave = {
							command = "clippy",
						},
						inlayHints = {
							lifetimeElisionHints = {
								enable = true,
								useParameterNames = true,
							},
						},
					},
				},
			},

			-- C/C++
			clangd = {
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders",
					"--fallback-style=llvm",
				},
				init_options = {
					usePlaceholders = true,
					completeUnimported = true,
					clangdFileStatus = true,
				},
			},

			-- Web development
			html = {},
			cssls = {},
			jsonls = {
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			},
			eslint = {
				settings = {
					codeAction = {
						disableRuleComment = {
							enable = true,
							location = "separateLine",
						},
						showDocumentation = {
							enable = true,
						},
					},
					codeActionOnSave = {
						enable = false,
						mode = "all",
					},
					format = true,
					nodePath = "",
					onIgnoredFiles = "off",
					packageManager = "npm",
					quiet = false,
					rulesCustomizations = {},
					run = "onType",
					useESLintClass = false,
					validate = "on",
					workingDirectory = {
						mode = "location",
					},
				},
			},

			-- Other servers
			tailwindcss = {},
			prismals = {},
			dockerls = {},
			yamlls = {
				settings = {
					yaml = {
						schemaStore = {
							enable = false,
							url = "",
						},
						schemas = require("schemastore").yaml.schemas(),
					},
				},
			},
			bashls = {},
			vimls = {},
		}

		-- Setup servers
		local mason_lspconfig = require("mason-lspconfig")
		mason_lspconfig.setup_handlers({
			function(server_name)
				local server_config = servers[server_name] or {}
				server_config.capabilities = capabilities
				server_config.on_attach = on_attach
				lspconfig[server_name].setup(server_config)
			end,
		})
	end,
}
