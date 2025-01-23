return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				java = { "google-java-format" },
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			-- make sure mason installs the server
			servers = {
				vtsls = {
					settings = {
						typescript = {
							inlayHints = {
								enumMemberValues = { enabled = false },
								functionLikeReturnTypes = { enabled = false },
								parameterNames = { enabled = false },
								parameterTypes = { enabled = false },
								propertyDeclarationTypes = { enabled = false },
								variableTypes = { enabled = false },
							},
						},
					},
					-- 	keys = {
					-- 		{
					-- 			"gD",
					-- 			function()
					-- 				local params = vim.lsp.util.make_position_params()
					-- 				LazyVim.lsp.execute({
					-- 					command = "typescript.goToSourceDefinition",
					-- 					arguments = { params.textDocument.uri, params.position },
					-- 					open = true,
					-- 				})
					-- 			end,
					-- 			desc = "Goto Source Definition",
					-- 		},
					-- 		{
					-- 			"gR",
					-- 			function()
					-- 				LazyVim.lsp.execute({
					-- 					command = "typescript.findAllFileReferences",
					-- 					arguments = { vim.uri_from_bufnr(0) },
					-- 					open = true,
					-- 				})
					-- 			end,
					-- 			desc = "File References",
					-- 		},
					-- 		{
					-- 			"<leader>co",
					-- 			LazyVim.lsp.action["source.organizeImports"],
					-- 			desc = "Organize Imports",
					-- 		},
					-- 		{
					-- 			"<leader>cM",
					-- 			LazyVim.lsp.action["source.addMissingImports.ts"],
					-- 			desc = "Add missing imports",
					-- 		},
					-- 		{
					-- 			"<leader>cu",
					-- 			LazyVim.lsp.action["source.removeUnused.ts"],
					-- 			desc = "Remove unused imports",
					-- 		},
					-- 		{
					-- 			"<leader>cD",
					-- 			LazyVim.lsp.action["source.fixAll.ts"],
					-- 			desc = "Fix all diagnostics",
					-- 		},
					-- 		{
					-- 			"<leader>cV",
					-- 			function()
					-- 				LazyVim.lsp.execute({ command = "typescript.selectTypeScriptVersion" })
					-- 			end,
					-- 			desc = "Select TS workspace version",
					-- 		},
					-- 	},
				},
			},
		},
	},
}
