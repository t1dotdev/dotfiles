return {
	-- messages, cmdline and the popupmenu
	{
		"folke/noice.nvim",
		opts = function(_, opts)
			table.insert(opts.routes, {
				filter = {
					event = "notify",
					find = "No information available",
				},
				opts = { skip = true },
			})
			local focused = true
			vim.api.nvim_create_autocmd("FocusGained", {
				callback = function()
					focused = true
				end,
			})
			vim.api.nvim_create_autocmd("FocusLost", {
				callback = function()
					focused = false
				end,
			})
			table.insert(opts.routes, 1, {
				filter = {
					cond = function()
						return not focused
					end,
				},
				view = "notify_send",
				opts = { stop = false },
			})

			opts.commands = {
				all = {
					-- options for the message history that you get with `:Noice`
					view = "split",
					opts = { enter = true, format = "details" },
					filter = {},
				},
			}

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "markdown",
				callback = function(event)
					vim.schedule(function()
						require("noice.text.markdown").keys(event.buf)
					end)
				end,
			})

			opts.presets.lsp_doc_border = true
		end,
	},

	{
		"rcarriga/nvim-notify",
		opts = {
			timeout = 5000,
		},
	},

	-- animations
	-- {
	-- 	"echasnovski/mini.animate",
	-- 	event = "VeryLazy",
	-- 	opts = function(_, opts)
	-- 		opts.scroll = {
	-- 			enable = false,
	-- 		}
	-- 	end,
	-- },

	-- buffer line
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		keys = {
			{ "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
			{ "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
		},
		opts = {
			options = {
				mode = "tabs",
				-- separator_style = "slant",
				show_buffer_close_icons = false,
				show_close_icon = false,
			},
		},
	},

	-- filename
	{
		"b0o/incline.nvim",
		dependencies = { "craftzdog/solarized-osaka.nvim" },
		event = "BufReadPre",
		priority = 1200,
		config = function()
			local colors = require("solarized-osaka.colors").setup()
			require("incline").setup({
				highlight = {
					groups = {
						InclineNormal = { guibg = "#905aff", guifg = colors.base04 },
						InclineNormalNC = { guifg = colors.violet500, guibg = colors.base03 },
					},
				},
				window = { margin = { vertical = 0, horizontal = 1 } },
				hide = {
					cursorline = true,
				},
				render = function(props)
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
					if vim.bo[props.buf].modified then
						filename = "[+] " .. filename
					end

					local icon, color = require("nvim-web-devicons").get_icon_color(filename)
					return { { icon, guifg = colors.base04 }, { " " }, { filename } }
				end,
			})
		end,
	},

	-- statusline
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local lualine = require("lualine")
			local lazy_status = require("lazy.status") -- to configure lazy pending updates count
			local LazyVim = require("lazyvim.util")

			local colors = {
				primary = "#905aff",
				blue = "#65D1FF",
				green = "#3EFFDC",
				violet = "#FF61EF",
				yellow = "#FFDA7B",
				red = "#FF4A4A",
				fg = "#c3ccdc",
				bg = "#000000",
				inactive_bg = "#2c3043",
			}

			local my_lualine_theme = {
				normal = {
					a = { bg = colors.primary, fg = colors.bg, gui = "bold" },
					-- b = { bg = colors.bg, fg = colors.fg },
					c = { fg = colors.fg },
				},
				insert = {
					a = { bg = colors.primary, fg = colors.bg, gui = "bold" },
					-- b = { bg = colors.bg, fg = colors.fg },
					-- c = { bg = colors.bg, fg = colors.fg },
					c = { fg = colors.fg },
				},
				visual = {
					a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
					-- b = { bg = colors.bg, fg = colors.fg },
					-- c = { bg = colors.bg, fg = colors.fg },
					c = { fg = colors.fg },
				},
				command = {
					a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
					-- b = { bg = colors.bg, fg = colors.fg },
					-- c = { bg = colors.bg, fg = colors.fg },
					c = { fg = colors.fg },
				},
				replace = {
					a = { bg = colors.red, fg = colors.bg, gui = "bold" },
					-- b = { bg = colors.bg, fg = colors.fg },
					-- c = { bg = colors.bg, fg = colors.fg },
					c = { fg = colors.fg },
				},
				inactive = {
					a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
					-- b = { bg = colors.inactive_bg, fg = colors.semilightgray },
					-- c = { bg = colors.inactive_bg, fg = colors.semilightgray },
					c = { fg = colors.fg },
				},
			}

			-- configure lualine with modified theme
			lualine.setup({
				options = {
					theme = my_lualine_theme,
				},
				sections = {
					lualine_c = {
						LazyVim.lualine.pretty_path({
							length = 0,
							relative = "cwd",
							modified_hl = "MatchParen",
							directory_hl = "",
							filename_hl = "Bold",
							modified_sign = "",
							readonly_icon = " 󰌾 ",
							color = { fg = colors.fg },
						}),
					},
					lualine_x = {
						{
							lazy_status.updates,
							cond = lazy_status.has_updates,
							color = { fg = "#ff9e64" },
						},
						-- { "encoding" },
						-- { "fileformat" },

						{ "filetype" },
					},
				},
			})
		end,
	},
	-- {
	-- 	"nvim-lualine/lualine.nvim",
	-- 	opts = function(_, opts)
	-- 		local LazyVim = require("lazyvim.util")
	-- 		opts.sections.lualine_c[4] = {
	-- 			LazyVim.lualine.pretty_path({
	-- 				length = 0,
	-- 				relative = "cwd",
	-- 				modified_hl = "MatchParen",
	-- 				directory_hl = "",
	-- 				filename_hl = "Bold",
	-- 				modified_sign = "",
	-- 				readonly_icon = " 󰌾 ",
	-- 			}),
	-- 		}
	-- 	end,
	-- },

	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		opts = {
			plugins = {
				gitsigns = true,
				tmux = true,
				kitty = { enabled = false, font = "+2" },
			},
		},
		keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
	},

	{
		"folke/snacks.nvim",
		opts = {
			dashboard = {
				pane_gap = 6,
				sections = {
					{ section = "header", padding = 2 },
					{ pane = 1, section = "keys", gap = 1, padding = 1 },
					{
						pane = 2,
						icon = " ",
						title = "Files",
						padding = 1,
					},
					{
						pane = 2,
						-- icon = " ",
						-- title = "Recent Files",
						section = "recent_files",
						indent = 3,
						padding = 2,
					},
					{
						pane = 2,
						icon = " ",
						title = "Projects",
						padding = 1,
					},
					{ pane = 2, section = "projects", indent = 3, padding = 2 },
					-- {
					-- 	pane = 2,
					-- 	section = "startup",
					-- },
					-- {
					-- 	pane = 2,
					-- 	icon = " ",
					-- 	title = "Git Status",
					-- 	section = "terminal",
					-- 	enabled = vim.fn.isdirectory(".git") == 1,
					-- 	cmd = "git status --short --branch --renames",
					-- 	height = 5,
					-- 	padding = 1,
					-- 	ttl = 5 * 60,
					-- 	indent = 3,
					-- },
				},
				preset = {
					-- 					header = [[
					--         tGCG1   1GCGt
					--         .L@@@f,f@@@L.
					--          .8@@@1@@@8.
					--         :8@@0: :0@@8:           ██╗    ██╗██╗████████╗███████╗██╗      █████╗ ██████╗
					--        i@@@G.   .G@@@i          ██║    ██║██║╚══██╔══╝██╔════╝██║     ██╔══██╗██╔══██╗
					--       t@@@L       L@@@t         ██║ █╗ ██║██║   ██║   █████╗  ██║     ███████║██████╔╝
					--      L@@@t   i0i   t@@@L        ██║███╗██║██║   ██║   ██╔══╝  ██║     ██╔══██║██╔══██╗
					--    .C@@@i   t@@@t   i@@@C.      ╚███╔███╔╝██║   ██║   ███████╗███████╗██║  ██║██████╔╝
					--   ,0@@8i ,,t@888@t,, i8@@0,      ╚══╝╚══╝ ╚═╝   ╚═╝   ╚══════╝╚══════╝╚═╝  ╚═╝╚═════╝
					--   0@@@@@@0;,.....,;0@@@@@@0
					--   ;LCCGGC:         :CGGCCL;
					-- ]],
					-- 					header = [[
					--       tGCG1   1GCGt
					--       .L@@@f,f@@@L.
					--        .8@@@1@@@8.
					--       :8@@0: :0@@8:             oooo     oooo o88    o8              ooooo                   oooo
					--      i@@@G.   .G@@@i             88   88  88  oooo o888oo ooooooooo8  888          ooooooo    888ooooo
					--     t@@@L       L@@@t             88 888 88    888  888  888oooooo8   888          ooooo888   888    888
					--    L@@@t   i0i   t@@@L              888 888     888  888  888          888      o 888    888   888    888
					--  .C@@@i   t@@@t   i@@@C.              8   8     o888o  888o  88oooo888 o888ooooo88  88ooo88 8o o888ooo88
					-- ,0@@8i ,,t@888@t,, i8@@0,
					-- 0@@@@@@0;,.....,;0@@@@@@0
					-- ;LCCGGC:         :CGGCCL;
					--     ]],
					header = [[
	██████╗ ███████╗████████╗ ██████╗██╗  ██╗██╗  ██╗
	██╔══██╗██╔════╝╚══██╔══╝██╔════╝██║  ██║╚██╗██╔╝
	██████╔╝█████╗     ██║   ██║     ███████║ ╚███╔╝
	██╔═══╝ ██╔══╝     ██║   ██║     ██╔══██║ ██╔██╗
	██║     ███████╗   ██║   ╚██████╗██║  ██║██╔╝ ██╗
	╚═╝     ╚══════╝   ╚═╝    ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝
]],

        -- stylua: ignore
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          -- { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
{ icon = " ", key = "g", desc = "Lazygit", action = ":lua require('lazygit').lazygit()", enabled = vim.fn.isdirectory(".git") == 1},
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
				},
			},
		},
		config = function(_, opts)
			require("snacks").setup(opts)

			-- Set highlight groups for Snacks Dashboard
			vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = "#905aff", bold = true })
			vim.api.nvim_set_hl(0, "SnacksDashboardKey", { fg = "#ffffff", bold = true })
			vim.api.nvim_set_hl(0, "SnacksDashboardFooter", { fg = "#905aff", italic = true })
			vim.api.nvim_set_hl(0, "SnacksDashboardIcon", { fg = "#ffffff", bold = true }) -- Pink for icons
			vim.api.nvim_set_hl(0, "SnacksDashboardDesc", { fg = "#ffffff", italic = true })
			vim.api.nvim_set_hl(0, "SnacksDashboardProjects", { fg = "#905aff", bold = true })

			vim.api.nvim_set_hl(0, "SnacksDashboardTitle", { fg = "#ffffff", bold = true }) -- Gold color for titles
			vim.api.nvim_set_hl(0, "SnacksDashboardIcon", { fg = "#905aff" }) -- Spring green for icons
			vim.api.nvim_set_hl(0, "SnacksDashboardFile", { fg = "#ffffff", bold = true }) -- Gold color for files
			vim.api.nvim_set_hl(0, "SnacksDashboardDir", { fg = "#905aff" }) -- Hot pink for directories
		end,
	},

	-- 	{
	-- 		"nvimdev/dashboard-nvim",
	-- 		-- enable = false,
	-- 		event = "VimEnter",
	-- 		opts = function(_, opts)
	-- 			vim.api.nvim_command("highlight DashboardHeader guifg=#905aff gui=bold")
	-- 			vim.api.nvim_command("highlight DashboardFooter guifg=#905aff gui=italic")
	-- 			local logo = [[
	-- ██████╗ ███████╗████████╗ ██████╗██╗  ██╗██╗  ██╗
	-- ██╔══██╗██╔════╝╚══██╔══╝██╔════╝██║  ██║╚██╗██╔╝
	-- ██████╔╝█████╗     ██║   ██║     ███████║ ╚███╔╝
	-- ██╔═══╝ ██╔══╝     ██║   ██║     ██╔══██║ ██╔██╗
	-- ██║     ███████╗   ██║   ╚██████╗██║  ██║██╔╝ ██╗
	-- ╚═╝     ╚══════╝   ╚═╝    ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝
	-- 		    ]]
	--
	-- 			logo = string.rep("\n", 8) .. logo .. "\n\n"
	-- 			opts.config.header = vim.split(logo, "\n")
	-- 		end,
	-- 	},
	{
		"kdheepak/lazygit.nvim",
		keys = {
			{
				"<leader>gg",
				":LazyGit<Return>",
				silent = true,
				noremap = true,
			},
		},

		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},

	{ "neo-tree.nvim", enabled = false },

	{
		"nvim-tree/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup({
				on_attach = function(bufnr)
					local api = require("nvim-tree.api")

					local function opts(desc)
						return {
							desc = "nvim-tree: " .. desc,
							buffer = bufnr,
							noremap = true,
							silent = true,
							nowait = true,
						}
					end

					-- default mappings
					api.config.mappings.default_on_attach(bufnr)

					-- custom mappings
					vim.keymap.set("n", "t", api.node.open.tab, opts("Tab"))
					vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
				end,
				actions = {
					open_file = {
						quit_on_open = true,
					},
				},
				sort = {
					sorter = "case_sensitive",
				},
				view = {
					-- width = 30,
					adaptive_size = true,
					relativenumber = true,
				},
				renderer = {
					group_empty = true,
				},
				filters = {
					dotfiles = true,
					custom = {
						"node_modules/.*",
					},
				},
				log = {
					enable = true,
					truncate = true,
					types = {
						diagnostics = true,
						git = true,
						profile = true,
						watcher = true,
					},
				},
			})

			-- if vim.fn.argc(-1) == 0 then
			-- 	vim.cmd("NvimTreeFocus")
			-- end
		end,
	},
}
