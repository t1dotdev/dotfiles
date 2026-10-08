local api = vim.api

-- Copilot integration: Hide copilot suggestions when blink menu is open
api.nvim_create_autocmd("User", {
	pattern = "BlinkCmpMenuOpen",
	callback = function()
		local ok, copilot = pcall(require, "copilot.suggestion")
		if ok then
			copilot.dismiss()
			vim.b.copilot_suggestion_hidden = true
		end
	end,
})

api.nvim_create_autocmd("User", {
	pattern = "BlinkCmpMenuClose",
	callback = function()
		vim.b.copilot_suggestion_hidden = false
	end,
})

api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
	callback = function(args)
		if vim.bo[args.buf].buftype == "prompt" then
			vim.b[args.buf].completion = false
		end
	end,
})

return {
	"saghen/blink.cmp",

	event = "InsertEnter",
	dependencies = { "rafamadriz/friendly-snippets" },
	version = "v1.*",

	opts = {
		enabled = function()
			if vim.bo.filetype == "dap-repl" then
				return true
			end

			if vim.bo.buftype == "prompt" then
				return false
			end

			if vim.bo.filetype == "snacks_input" then
				return false
			end

			return vim.b.completion ~= false
		end,

		-- Keymap configuration
		keymap = {
			preset = "default",
			["<C-k>"] = { "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
			["<Tab>"] = {
				function()
					-- Check if Copilot suggestion is visible and accept it
					local ok, copilot = pcall(require, "copilot.suggestion")
					if ok and copilot.is_visible() then
						copilot.accept()
						return true
					end
				end,
				"snippet_forward",
				"select_and_accept",
				"fallback",
			},
			["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
			["<CR>"] = { "accept", "fallback" },
			["<C-e>"] = { "cancel", "fallback" },
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-l>"] = { "snippet_forward", "fallback" },
			["<C-h>"] = { "snippet_backward", "fallback" },
		},

		-- Appearance
		appearance = {
			nerd_font_variant = "mono",
		},

		-- Fuzzy matching with Rust implementation for better performance
		fuzzy = {
			implementation = "prefer_rust_with_warning",
			-- Context-aware sorting: prioritize LSP for imports, snippets for code
			sorts = {
				-- Smart source priority based on context
				function(a, b)
					-- Get current line number
					local current_line_num = vim.api.nvim_win_get_cursor(0)[1]

					-- Dynamic priority based on context
					local source_priority
					if current_line_num == 1 then
						-- Only prioritize snippets on the first line
						source_priority = {
							snippets = 4,
							lsp = 3,
							path = 2,
							buffer = 1,
						}
					else
						-- Prioritize LSP everywhere else
						source_priority = {
							lsp = 4,
							path = 3,
							snippets = 2,
							buffer = 1,
						}
					end

					local a_priority = source_priority[a.source_id] or 0
					local b_priority = source_priority[b.source_id] or 0
					if a_priority ~= b_priority then
						return a_priority > b_priority
					end
				end,
				-- Then sort by score within each source
				"score",
				"sort_text",
			},
		},

		-- Completion configuration
		completion = {
			accept = {
				auto_brackets = {
					enabled = true,
					default_brackets = { "(", ")" },
					override_brackets_for_filetypes = {},
					force_allow_filetypes = {},
					blocked_filetypes = {},
					kind_resolution = {
						enabled = true,
						blocked_filetypes = { "typescriptreact", "javascriptreact", "vue" },
					},
					semantic_token_resolution = {
						enabled = true,
						blocked_filetypes = {},
					},
				},
			},

			trigger = {
				show_on_keyword = true,
				show_on_trigger_character = true,
				show_on_accept_on_trigger_character = true,
				show_on_insert_on_trigger_character = true,
				show_on_x_blocked_trigger_characters = { "'", '"', "(" },
				show_in_snippet = true,
			},

			list = {
				selection = {
					preselect = true,
					auto_insert = true,
				},
				max_items = 200,
			},

			menu = {
				enabled = true,
				min_width = 15,
				max_height = 10,
				border = "rounded",
				winblend = 0,
				scrollbar = false,
				winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
				scrolloff = 2,
				draw = {
					treesitter = { "lsp" },
					padding = 0,
					gap = 1,
					columns = {
						{ "kind_icon" },
						{ "label", "label_description", gap = 1 },
						{ "source_name" },
					},
					components = {
						kind_icon = {
							ellipsis = false,
							text = function(ctx)
								if ctx.kind == "Color" then
									return "  "
								end
								return (" " .. (ctx.kind_icon or "") .. " ")
							end,
							highlight = function(ctx)
								local kind = ctx.kind or ""
								if kind == "Color" then
									return ctx.kind_hl
								end
								return "BlinkCmpKind" .. kind
							end,
						},
						label = {
							width = { fill = true, max = 60 },
							text = function(ctx)
								return ctx.label .. (ctx.label_detail or "")
							end,
							highlight = function(ctx)
								-- Highlight matching characters
								local highlights = {}
								for _, idx in ipairs(ctx.label_matched_indices or {}) do
									table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
								end
								return highlights
							end,
						},
						label_description = {
							width = { max = 30 },
							text = function(ctx)
								return ctx.label_description
							end,
							highlight = "BlinkCmpLabelDescription",
						},
						source_name = {
							width = { max = 30 },
							text = function(ctx)
								return "[" .. ctx.source_name .. "]"
							end,
							highlight = "BlinkCmpSource",
						},
					},
				},
			},

			documentation = {
				auto_show = true,
				auto_show_delay_ms = 100,
				update_delay_ms = 50,
				treesitter_highlighting = true,
				window = {
					min_width = 10,
					max_width = 60,
					max_height = 20,
					border = "rounded",
					winblend = 0,
					winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
					scrollbar = true,
				},
			},

			ghost_text = {
				enabled = true,
			},
		},

		-- Signature help
		signature = {
			enabled = true,
			trigger = {
				blocked_trigger_characters = {},
				blocked_retrigger_characters = {},
				show_on_insert_on_trigger_character = true,
			},
			window = {
				min_width = 1,
				max_width = 100,
				max_height = 10,
				border = "rounded",
				winblend = 0,
				winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
				scrollbar = false,
			},
		},

		-- Source configuration
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
			per_filetype = {
				-- Minimal sources for config files
				yaml = { "lsp", "path", "buffer" },
				toml = { "path", "buffer" },
				json = { "lsp", "path", "buffer" },

				-- Documentation
				markdown = { "lsp", "path", "buffer", "snippets" },
				help = { "path", "buffer" },

				-- Git
				gitcommit = { "buffer" },
				gitrebase = { "buffer" },
			},

			providers = {
				snippets = {
					name = "Snippets",
					enabled = true,
					module = "blink.cmp.sources.snippets",
					score_offset = 200, -- Increased to ensure snippets are prioritized
					max_items = 10,
				},

				lsp = {
					name = "LSP",
					enabled = true,
					module = "blink.cmp.sources.lsp",
					fallbacks = { "buffer" },
					score_offset = 0, -- Reset to baseline since custom sort handles priority
				},

				buffer = {
					name = "Buffer",
					enabled = true,
					module = "blink.cmp.sources.buffer",
					min_keyword_length = 3,
					score_offset = -50, -- Lower priority
					max_items = 10,
				},

				path = {
					name = "Path",
					enabled = true,
					module = "blink.cmp.sources.path",
					score_offset = -30, -- Lower priority
				},
			},
		},

		-- Cmdline configuration
		cmdline = {
			enabled = true,
			sources = { "path", "cmdline" },
			keymap = {
				preset = "cmdline",
				["<C-k>"] = { "select_prev", "fallback" },
				["<C-j>"] = { "select_next", "fallback" },
				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<Tab>"] = { "select_and_accept", "fallback" },
			},
			completion = {
				menu = {
					auto_show = true,
				},
			},
		},
	},

	-- Extend the default sources
	opts_extend = { "sources.default" },
}
