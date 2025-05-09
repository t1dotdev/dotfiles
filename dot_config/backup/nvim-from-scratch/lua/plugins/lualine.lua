return {
	-- statusline
	{
		"nvim-lualine/lualine.nvim",
		-- enabled = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local lualine = require("lualine")
			local lazy_status = require("lazy.status")

			-- Soft modern color palette
			local colors = {
				primary = "#875fff", -- soft violet
				blue = "#60a5fa", -- soft blue
				green = "#34d399", -- teal-green
				violet = "#f472b6", -- pink-violet
				yellow = "#facc15", -- warm yellow
				red = "#f87171", -- soft red
				fg = "#cbd5e1", -- slate-200
				bg = nil, -- transparent
				inactive_bg = nil,
			}

			local my_lualine_theme = {
				normal = {
					a = { bg = colors.primary, fg = colors.bg, gui = "bold" },
					c = { fg = colors.fg, bg = colors.bg },
				},
				insert = {
					a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
					c = { fg = colors.fg, bg = colors.bg },
				},
				visual = {
					a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
					c = { fg = colors.fg, bg = colors.bg },
				},
				command = {
					a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
					c = { fg = colors.fg, bg = colors.bg },
				},
				replace = {
					a = { bg = colors.red, fg = colors.bg, gui = "bold" },
					c = { fg = colors.fg, bg = colors.bg },
				},
				inactive = {
					a = { fg = "#94a3b8", bg = colors.bg, gui = "bold" },
					c = { fg = colors.fg, bg = colors.bg },
				},
			}

			lualine.setup({
				options = {
					theme = my_lualine_theme,
					section_separators = "",
					component_separators = "",
					globalstatus = true,
				},
				sections = {
					lualine_x = {
						{
							lazy_status.updates,
							cond = lazy_status.has_updates,
							color = { fg = "#ff9e64" },
						},
						{ "filetype" },
					},
				},
			})
		end,
	},
}
