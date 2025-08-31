return {
	"nvim-tree/nvim-tree.lua",
	cmd = { "NvimTreeToggle", "NvimTreeFocus" },
	event = "VeryLazy",
	keys = {
		{ "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle File Explorer" },
	},
	config = function()
		require("nvim-tree").setup({
			disable_netrw = true,
			hijack_cursor = true,
			sync_root_with_cwd = true,
			actions = {
				open_file = {
					quit_on_open = true,
				},
			},
			update_focused_file = {
				enable = true,
				update_root = false,
			},
			sort = {
				sorter = "case_sensitive",
			},
			view = {
				preserve_window_proportions = true,
				width = 30,
				adaptive_size = true,
				relativenumber = true,
			},
			renderer = {
				root_folder_label = false,
				highlight_git = true,
				indent_markers = { enable = true },
				icons = {
					glyphs = {
						default = "󰈚",
						folder = {
							default = "",
							empty = "",
							empty_open = "",
							open = "",
							symlink = "",
						},
						git = { unmerged = "" },
					},
				},
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
		vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle File Explorer" })
	end,
}
