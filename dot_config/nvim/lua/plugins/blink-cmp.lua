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

return {
	"saghen/blink.cmp",

	event = "InsertEnter",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"nvim-tree/nvim-web-devicons",
		-- Optional: Add these if you want specific integrations
		-- 'giuxtaposition/blink-cmp-copilot',
		-- 'L3MON4D3/LuaSnip',
	},
	version = "v1.*",

	opts = {
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
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
		},

		-- Fuzzy matching with Rust implementation for better performance
		fuzzy = {
			implementation = "prefer_rust_with_warning",
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
				show_in_snippet = false,
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
				-- Special sources for specific filetypes
				codecompanion = { "codecompanion" },

				-- Languages with different source priorities
				lua = { "lsp", "path", "snippets", "buffer" },
				python = { "lsp", "path", "snippets", "buffer" },
				go = { "lsp", "path", "snippets", "buffer" },
				rust = { "lsp", "path", "snippets", "buffer" },

				-- Web development
				javascript = { "lsp", "path", "snippets", "buffer" },
				typescript = { "lsp", "path", "snippets", "buffer" },
				typescriptreact = { "lsp", "path", "snippets", "buffer" },
				javascriptreact = { "lsp", "path", "snippets", "buffer" },
				vue = { "lsp", "path", "snippets", "buffer" },

				-- Minimal sources for config files
				yaml = { "path", "buffer" },
				toml = { "path", "buffer" },
				json = { "lsp", "path", "buffer" },

				-- Documentation
				markdown = { "path", "buffer", "snippets" },
				help = { "path", "buffer" },

				-- Git
				gitcommit = { "buffer" },
				gitrebase = { "buffer" },
			},

			providers = {
				lsp = {
					name = "LSP",
					enabled = true,
					module = "blink.cmp.sources.lsp",
					fallbacks = { "buffer" },
					score_offset = 90,
				},

				buffer = {
					name = "Buffer",
					enabled = true,
					module = "blink.cmp.sources.buffer",
					min_keyword_length = 3,
					score_offset = 50,
					max_items = 10,
				},

				path = {
					name = "Path",
					enabled = true,
					module = "blink.cmp.sources.path",
					score_offset = 30,
				},

				snippets = {
					name = "Snippets",
					enabled = true,
					module = "blink.cmp.sources.snippets",
					score_offset = 80,
					max_items = 10,
				},

				-- Optional: Copilot provider (uncomment if using blink-cmp-copilot)
				-- copilot = {
				-- 	name = 'Copilot',
				-- 	module = 'blink-cmp-copilot',
				-- 	enabled = true,
				-- 	async = true,
				-- 	score_offset = 100,
				-- 	min_keyword_length = 2,
				-- },
			},
		},

		-- Cmdline configuration
		cmdline = {
			enabled = true,
			sources = {
				default = { "path", "cmdline" },
			},
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

		-- Snippets configuration (if using LuaSnip)
		snippets = {
			-- preset = 'luasnip', -- Uncomment if using LuaSnip
			expand = function(snippet)
				-- If using LuaSnip
				-- local ls = require('luasnip')
				-- if ls then
				-- 	ls.lsp_expand(snippet)
				-- end

				-- Default snippet expansion
				vim.snippet.expand(snippet)
			end,
			active = function(filter)
				-- If using LuaSnip
				-- local ls = require('luasnip')
				-- if ls then
				-- 	if filter and filter.direction then
				-- 		return ls.jumpable(filter.direction)
				-- 	end
				-- 	return ls.in_snippet()
				-- end

				-- Default snippet check
				return vim.snippet.active(filter)
			end,
			jump = function(direction)
				-- If using LuaSnip
				-- local ls = require('luasnip')
				-- if ls then
				-- 	ls.jump(direction)
				-- end

				-- Default snippet jump
				vim.snippet.jump(direction)
			end,
		},
	},

	-- Extend the default sources
	opts_extend = { "sources.default" },

	config = function(_, opts)
		-- Setup blink.cmp
		local blink = require("blink.cmp")
		blink.setup(opts)

		-- Setup Copilot if available (for native copilot.lua integration)
		local ok, copilot = pcall(require, "copilot")
		if ok then
			copilot.setup({
				suggestion = {
					enabled = true,
					auto_trigger = true,
					debounce = 75,
				},
				panel = { enabled = false },
				filetypes = {
					["*"] = true,
					yaml = false,
					markdown = false,
					help = false,
					gitcommit = false,
					gitrebase = false,
					["."] = false,
					[""] = false,
				},
			})
		end

		-- Define custom highlight groups
		-- local highlights = {
		-- 	-- Borders
		-- 	BlinkCmpMenuBorder = { link = "FloatBorder" },
		-- 	BlinkCmpDocBorder = { link = "FloatBorder" },
		-- 	BlinkCmpSignatureHelpBorder = { link = "FloatBorder" },
		--
		-- 	-- Menu
		-- 	BlinkCmpMenu = { link = "Pmenu" },
		-- 	BlinkCmpMenuSelection = { link = "PmenuSel" },
		-- 	BlinkCmpLabelMatch = { fg = "#83a598", bold = true },
		-- 	BlinkCmpLabelDescription = { fg = "#928374", italic = true },
		-- 	BlinkCmpSource = { fg = "#928374", italic = true },
		--
		-- 	-- Documentation
		-- 	BlinkCmpDoc = { link = "NormalFloat" },
		-- 	BlinkCmpSignatureHelp = { link = "NormalFloat" },
		--
		-- 	-- Kind highlights (using gruvbox-like colors as example)
		-- 	BlinkCmpKindText = { fg = "#ebdbb2" },
		-- 	BlinkCmpKindMethod = { fg = "#83a598" },
		-- 	BlinkCmpKindFunction = { fg = "#83a598" },
		-- 	BlinkCmpKindConstructor = { fg = "#fabd2f" },
		-- 	BlinkCmpKindField = { fg = "#8ec07c" },
		-- 	BlinkCmpKindVariable = { fg = "#ebdbb2" },
		-- 	BlinkCmpKindClass = { fg = "#fabd2f" },
		-- 	BlinkCmpKindInterface = { fg = "#fabd2f" },
		-- 	BlinkCmpKindModule = { fg = "#fabd2f" },
		-- 	BlinkCmpKindProperty = { fg = "#8ec07c" },
		-- 	BlinkCmpKindUnit = { fg = "#d3869b" },
		-- 	BlinkCmpKindValue = { fg = "#d3869b" },
		-- 	BlinkCmpKindEnum = { fg = "#fabd2f" },
		-- 	BlinkCmpKindKeyword = { fg = "#fb4934" },
		-- 	BlinkCmpKindSnippet = { fg = "#d3869b" },
		-- 	BlinkCmpKindColor = { fg = "#d3869b" },
		-- 	BlinkCmpKindFile = { fg = "#ebdbb2" },
		-- 	BlinkCmpKindReference = { fg = "#ebdbb2" },
		-- 	BlinkCmpKindFolder = { fg = "#ebdbb2" },
		-- 	BlinkCmpKindEnumMember = { fg = "#d3869b" },
		-- 	BlinkCmpKindConstant = { fg = "#d3869b" },
		-- 	BlinkCmpKindStruct = { fg = "#fabd2f" },
		-- 	BlinkCmpKindEvent = { fg = "#fabd2f" },
		-- 	BlinkCmpKindOperator = { fg = "#ebdbb2" },
		-- 	BlinkCmpKindTypeParameter = { fg = "#8ec07c" },
		-- }
		--
		-- for name, hl in pairs(highlights) do
		-- 	vim.api.nvim_set_hl(0, name, hl)
		-- end

		-- Optional: Setup additional keymaps for snippet navigation if using LuaSnip
		-- vim.keymap.set({ 'i', 's' }, '<C-l>', function()
		-- 	local ls = require('luasnip')
		-- 	if ls.expand_or_jumpable() then
		-- 		ls.expand_or_jump()
		-- 	end
		-- end, { silent = true })
		--
		-- vim.keymap.set({ 'i', 's' }, '<C-h>', function()
		-- 	local ls = require('luasnip')
		-- 	if ls.jumpable(-1) then
		-- 		ls.jump(-1)
		-- 	end
		-- end, { silent = true })
	end,
}
