return {
	{
		"saghen/blink.cmp",
		event = "InsertEnter",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"giuxtaposition/blink-cmp-copilot",
			"onsails/lspkind.nvim",
		},
		version = "*",
		opts = {
			keymap = {
				preset = "default",
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide" },
				["<Tab>"] = {
					function(cmp)
						if cmp.snippet_active() then
							return cmp.accept()
						else
							return cmp.select_next()
						end
					end,
					"snippet_forward",
					"fallback",
				},
				["<S-Tab>"] = {
					function(cmp)
						if cmp.snippet_active() then
							return cmp.snippet_backward()
						else
							return cmp.select_prev()
						end
					end,
					"fallback",
				},
				["<CR>"] = { "accept", "fallback" },
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
			},

			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
				kind_icons = {
					Text = "󰉿",
					Method = "󰊕",
					Function = "󰊕",
					Constructor = "󰒉",
					Field = "󰜢",
					Variable = "󰆦",
					Class = "󰠱",
					Interface = "󰜰",
					Module = "󰏗",
					Property = "󰜢",
					Unit = "󰑭",
					Value = "󰎠",
					Enum = "󰕘",
					Keyword = "󰌆",
					Snippet = "󰩫",
					Color = "󰏘",
					File = "󰈔",
					Reference = "󰈇",
					Folder = "󰉋",
					EnumMember = "󰕘",
					Constant = "󰏿",
					Struct = "󰠱",
					Event = "󰉁",
					Operator = "󰆕",
					TypeParameter = "󰊄",
					Copilot = "",
				},
			},

			sources = {
				default = { "lsp", "path", "snippets", "buffer", "copilot" },
				providers = {
					lsp = {
						name = "LSP",
						enabled = true,
						module = "blink.cmp.sources.lsp",
						fallbacks = { "buffer" },
						score_offset = 90,
					},
					path = {
						name = "Path",
						module = "blink.cmp.sources.path",
						score_offset = 3,
						opts = {
							trailing_slash = false,
							label_trailing_slash = true,
						},
					},
					snippets = {
						name = "Snippets",
						enabled = true,
						module = "blink.cmp.sources.snippets",
						score_offset = 80,
					},
					buffer = {
						name = "Buffer",
						enabled = true,
						module = "blink.cmp.sources.buffer",
						fallbacks = {},
					},
					copilot = {
						name = "copilot",
						module = "blink-cmp-copilot",
						score_offset = 100,
						async = true,
						enabled = true,
					},
				},
			},

			completion = {
				accept = {
					auto_brackets = {
						enabled = true,
					},
				},
				menu = {
					enabled = true,
					border = "rounded",
					winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
					draw = {
						treesitter = { "lsp" },
						columns = {
							{ "kind_icon", "kind", gap = 1 },
							{ "label", "label_description", gap = 1 },
							{ "source_name" },
						},
						components = {
							kind_icon = {
								ellipsis = false,
								text = function(ctx)
									return " " .. ctx.kind_icon .. " "
								end,
								highlight = function(ctx)
									return "CmpItemKind" .. ctx.kind
								end,
							},
						},
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
					window = {
						border = "rounded",
						winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
					},
				},
				ghost_text = {
					enabled = true,
				},
			},

			signature = {
				enabled = true,
				window = {
					border = "rounded",
					winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
				},
			},
		},
		opts_extend = { "sources.default" },
	},
}
