return {
	-- messages, cmdline and the popupmenu
	{
		"snacks.nvim",
		opts = {
			scroll = { enabled = false },
		},
	},

	-- buffer line
	-- {
	-- 	"akinsho/bufferline.nvim",
	-- 	event = "VeryLazy",
	-- 	keys = {
	-- 		{ "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
	-- 		{ "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
	-- 	},
	-- 	opts = {
	-- 		options = {
	-- 			mode = "tabs",
	-- 			-- separator_style = "slant",
	-- 			show_buffer_close_icons = false,
	-- 			show_close_icon = false,
	-- 		},
	-- 	},
	-- },

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

	{
		"snacks.nvim",
		opts = {
			dashboard = {
				preset = {
					header = [[
████████╗ ██╗██████╗  ██████╗ ████████╗██████╗ ███████╗██╗   ██╗
╚══██╔══╝███║██╔══██╗██╔═══██╗╚══██╔══╝██╔══██╗██╔════╝██║   ██║
   ██║   ╚██║██║  ██║██║   ██║   ██║   ██║  ██║█████╗  ██║   ██║
   ██║    ██║██║  ██║██║   ██║   ██║   ██║  ██║██╔══╝  ╚██╗ ██╔╝
   ██║    ██║██████╔╝╚██████╔╝   ██║   ██████╔╝███████╗ ╚████╔╝ 
   ╚═╝    ╚═╝╚═════╝  ╚═════╝    ╚═╝   ╚═════╝ ╚══════╝  ╚═══╝  
 ]],
        -- stylua: ignore
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          -- { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "g", desc = "Lazygit", action = ":lua require('lazygit').lazygit()", enabled = vim.fn.isdirectory(".git") == 1},
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
				},
			},
		},
		config = function(_, opts)
			require("snacks").setup(opts)

			-- Function to set highlight groups
			local function set_snacks_highlights()
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
			end

			-- Apply highlights immediately
			set_snacks_highlights()

			-- Reapply highlights after colorscheme changes
			vim.api.nvim_create_autocmd("ColorScheme", {
				callback = set_snacks_highlights,
			})
		end,
	},

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
}
