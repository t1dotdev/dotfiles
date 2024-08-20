return {
	-- tools
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				"luacheck",
				"shellcheck",
				"shfmt",
				"tailwindcss-language-server",
				"typescript-language-server",
				"css-lsp",
				"eslint-lsp",
			})
		end,
	},

	{
		"neovim/nvim-lspconfig",
		opts = {
			-- make sure mason installs the server
			servers = {
				tsserver = {
					enabled = false,
				},
				vtsls = {
					-- explicitly add default filetypes, so that we can extend
					-- them in related extras
					filetypes = {
						"javascript",
						"javascriptreact",
						"javascript.jsx",
						"typescript",
						"typescriptreact",
						"typescript.tsx",
					},
					settings = {
						complete_function_calls = true,
						vtsls = {
							enableMoveToFileCodeAction = true,
							autoUseWorkspaceTsdk = true,
							experimental = {
								completion = {
									enableServerSideFuzzyMatch = true,
								},
							},
						},
						typescript = {
							updateImportsOnFileMove = { enabled = "always" },
							suggest = {
								completeFunctionCalls = true,
							},
							inlayHints = {
								enumMemberValues = { enabled = true },
								functionLikeReturnTypes = { enabled = true },
								parameterNames = { enabled = "literals" },
								parameterTypes = { enabled = true },
								propertyDeclarationTypes = { enabled = true },
								variableTypes = { enabled = false },
							},
						},
					},
					keys = {
						{
							"gD",
							function()
								local params = vim.lsp.util.make_position_params()
								LazyVim.lsp.execute({
									command = "typescript.goToSourceDefinition",
									arguments = { params.textDocument.uri, params.position },
									open = true,
								})
							end,
							desc = "Goto Source Definition",
						},
						{
							"gR",
							function()
								LazyVim.lsp.execute({
									command = "typescript.findAllFileReferences",
									arguments = { vim.uri_from_bufnr(0) },
									open = true,
								})
							end,
							desc = "File References",
						},
						{
							"<leader>co",
							LazyVim.lsp.action["source.organizeImports"],
							desc = "Organize Imports",
						},
						{
							"<leader>cM",
							LazyVim.lsp.action["source.addMissingImports.ts"],
							desc = "Add missing imports",
						},
						{
							"<leader>cu",
							LazyVim.lsp.action["source.removeUnused.ts"],
							desc = "Remove unused imports",
						},
						{
							"<leader>cD",
							LazyVim.lsp.action["source.fixAll.ts"],
							desc = "Fix all diagnostics",
						},
						{
							"<leader>cV",
							function()
								LazyVim.lsp.execute({ command = "typescript.selectTypeScriptVersion" })
							end,
							desc = "Select TS workspace version",
						},
					},
				},
			},
			setup = {
				tsserver = function()
					-- disable tsserver
					return true
				end,
				vtsls = function(_, opts)
					LazyVim.lsp.on_attach(function(client, buffer)
						client.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
							---@type string, string, lsp.Range
							local action, uri, range = unpack(command.arguments)

							local function move(newf)
								client.request("workspace/executeCommand", {
									command = command.command,
									arguments = { action, uri, range, newf },
								})
							end

							local fname = vim.uri_to_fname(uri)
							client.request("workspace/executeCommand", {
								command = "typescript.tsserverRequest",
								arguments = {
									"getMoveToRefactoringFileSuggestions",
									{
										file = fname,
										startLine = range.start.line + 1,
										startOffset = range.start.character + 1,
										endLine = range["end"].line + 1,
										endOffset = range["end"].character + 1,
									},
								},
							}, function(_, result)
								---@type string[]
								local files = result.body.files
								table.insert(files, 1, "Enter new path...")
								vim.ui.select(files, {
									prompt = "Select move destination:",
									format_item = function(f)
										return vim.fn.fnamemodify(f, ":~:.")
									end,
								}, function(f)
									if f and f:find("^Enter new path") then
										vim.ui.input({
											prompt = "Enter move destination:",
											default = vim.fn.fnamemodify(fname, ":h") .. "/",
											completion = "file",
										}, function(newf)
											return newf and move(newf)
										end)
									elseif f then
										move(f)
									end
								end)
							end)
						end
					end, "vtsls")
					-- copy typescript settings to javascript
					opts.settings.javascript =
						vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})
				end,
			},
		},
	},

	-- lsp servers
	-- {
	-- 	"neovim/nvim-lspconfig",
	-- 	opts = {
	-- 		inlay_hints = { enabled = true },
	-- 		---@type lspconfig.options
	-- 		servers = {
	-- 			cssls = {},
	-- 			tailwindcss = {
	-- 				root_dir = function(...)
	-- 					return require("lspconfig.util").root_pattern(".git")(...)
	-- 				end,
	-- 			},
	-- 			tsserver = {
	-- 				root_dir = function(...)
	-- 					return require("lspconfig.util").root_pattern(".git")(...)
	-- 				end,
	-- 				single_file_support = false,
	-- 				settings = {
	-- 					typescript = {
	-- 						inlayHints = {
	-- 							includeInlayParameterNameHints = "literal",
	-- 							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
	-- 							includeInlayFunctionParameterTypeHints = true,
	-- 							includeInlayVariableTypeHints = false,
	-- 							includeInlayPropertyDeclarationTypeHints = true,
	-- 							includeInlayFunctionLikeReturnTypeHints = true,
	-- 							includeInlayEnumMemberValueHints = true,
	-- 						},
	-- 					},
	-- 					javascript = {
	-- 						inlayHints = {
	-- 							includeInlayParameterNameHints = "all",
	-- 							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
	-- 							includeInlayFunctionParameterTypeHints = true,
	-- 							includeInlayVariableTypeHints = true,
	-- 							includeInlayPropertyDeclarationTypeHints = true,
	-- 							includeInlayFunctionLikeReturnTypeHints = true,
	-- 							includeInlayEnumMemberValueHints = true,
	-- 						},
	-- 					},
	-- 				},
	-- 			},
	-- 			html = {},
	-- 			lua_ls = {
	-- 				-- enabled = false,
	-- 				single_file_support = true,
	-- 				settings = {
	-- 					Lua = {
	-- 						workspace = {
	-- 							checkThirdParty = false,
	-- 						},
	-- 						completion = {
	-- 							workspaceWord = true,
	-- 							callSnippet = "Both",
	-- 						},
	-- 						misc = {
	-- 							parameters = {
	-- 								-- "--log-level=trace",
	-- 							},
	-- 						},
	-- 						hint = {
	-- 							enable = true,
	-- 							setType = false,
	-- 							paramType = true,
	-- 							paramName = "Disable",
	-- 							semicolon = "Disable",
	-- 							arrayIndex = "Disable",
	-- 						},
	-- 						doc = {
	-- 							privateName = { "^_" },
	-- 						},
	-- 						type = {
	-- 							castNumberToInteger = true,
	-- 						},
	-- 						diagnostics = {
	-- 							disable = { "incomplete-signature-doc", "trailing-space" },
	-- 							-- enable = false,
	-- 							groupSeverity = {
	-- 								strong = "Warning",
	-- 								strict = "Warning",
	-- 							},
	-- 							groupFileStatus = {
	-- 								["ambiguity"] = "Opened",
	-- 								["await"] = "Opened",
	-- 								["codestyle"] = "None",
	-- 								["duplicate"] = "Opened",
	-- 								["global"] = "Opened",
	-- 								["luadoc"] = "Opened",
	-- 								["redefined"] = "Opened",
	-- 								["strict"] = "Opened",
	-- 								["strong"] = "Opened",
	-- 								["type-check"] = "Opened",
	-- 								["unbalanced"] = "Opened",
	-- 								["unused"] = "Opened",
	-- 							},
	-- 							unusedLocalExclude = { "_*" },
	-- 						},
	-- 						format = {
	-- 							enable = false,
	-- 							defaultConfig = {
	-- 								indent_style = "space",
	-- 								indent_size = "2",
	-- 								continuation_indent_size = "2",
	-- 							},
	-- 						},
	-- 					},
	-- 				},
	-- 			},
	-- 		},
	-- 		setup = {},
	-- 	},
	-- },
	{
		"L3MON4D3/LuaSnip",
		lazy = true,
		build = (not LazyVim.is_win())
				and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
			or nil,
		dependencies = {
			{
				"rafamadriz/friendly-snippets",
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},
			{
				"nvim-cmp",
				dependencies = {
					"saadparwaiz1/cmp_luasnip",
				},
				opts = function(_, opts)
					opts.snippet = {
						expand = function(args)
							require("luasnip").lsp_expand(args.body)
						end,
					}
					table.insert(opts.sources, { name = "luasnip" })
				end,
			},
		},
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
	},
	{
		"nvim-cmp",
		dependencies = { "hrsh7th/cmp-emoji" },
		opts = function(_, opts)
			table.insert(opts.sources, { name = "emoji" })
		end,
	},
}
