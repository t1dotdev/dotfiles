return {
	{ "neo-tree.nvim", enabled = false },
	-- {
	-- 	"nvim-tree/nvim-tree.lua",
	-- 	cmd = { "NvimTreeToggle", "NvimTreeFocus" },
	-- 	event = "VimEnter", -- ensures it's available during session restore
	-- 	keys = {
	-- 		{ "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle File Explorer" },
	-- 	},
	-- 	config = function()
	-- 		require("nvim-tree").setup({
	-- 			disable_netrw = true,
	-- 			hijack_cursor = true,
	-- 			sync_root_with_cwd = true,
	-- 			actions = {
	-- 				open_file = {
	-- 					quit_on_open = true,
	-- 				},
	-- 			},
	-- 			update_focused_file = {
	-- 				enable = true,
	-- 				update_root = false,
	-- 			},
	-- 			sort = {
	-- 				sorter = "case_sensitive",
	-- 			},
	-- 			view = {
	-- 				preserve_window_proportions = true,
	-- 				width = 30,
	-- 				adaptive_size = true,
	-- 				relativenumber = true,
	-- 			},
	-- 			renderer = {
	-- 				root_folder_label = false,
	-- 				highlight_git = true,
	-- 				indent_markers = { enable = true },
	-- 				icons = {
	-- 					glyphs = {
	-- 						default = "󰈚",
	-- 						folder = {
	-- 							default = "",
	-- 							empty = "",
	-- 							empty_open = "",
	-- 							open = "",
	-- 							symlink = "",
	-- 						},
	-- 						git = { unmerged = "" },
	-- 					},
	-- 				},
	-- 			},
	-- 			filters = {
	-- 				dotfiles = true,
	-- 				custom = {
	-- 					"node_modules/.*",
	-- 				},
	-- 			},
	-- 			log = {
	-- 				enable = true,
	-- 				truncate = true,
	-- 				types = {
	-- 					diagnostics = true,
	-- 					git = true,
	-- 					profile = true,
	-- 					watcher = true,
	-- 				},
	-- 			},
	-- 		})
	-- 		vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle File Explorer" })
	-- 	end,
	-- },

	{
		"echasnovski/mini.hipatterns",
		event = "BufReadPre",
		opts = {
			highlighters = {
				hsl_color = {
					pattern = "hsl%(%d+,? %d+%%?,? %d+%%?%)",
					group = function(_, match)
						local utils = require("solarized-osaka.hsl")
						--- @type string, string, string
						local nh, ns, nl = match:match("hsl%((%d+),? (%d+)%%?,? (%d+)%%?%)")
						--- @type number?, number?, number?
						local h, s, l = tonumber(nh), tonumber(ns), tonumber(nl)
						--- @type string
						local hex_color = utils.hslToHex(h, s, l)
						return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
					end,
				},
			},
		},
	},
}
