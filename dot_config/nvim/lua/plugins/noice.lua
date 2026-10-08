-- lazy.nvim
return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		-- vim.notify is owned by snacks.notifier (history: <leader>n)
		notify = { enabled = false },
		routes = {
			{
				filter = {
					event = "msg_show",
					any = {
						{ find = "%d+L, %d+B" },
						{ find = "; after #%d+" },
						{ find = "; before #%d+" },
						{ find = "%d fewer lines" },
						{ find = "%d more lines" },
					},
				},
				view = "mini",
			},
		},
		presets = {
			bottom_search = true,
			command_palette = true,
			long_message_to_split = true,
		},
	},
	dependencies = { "MunifTanjim/nui.nvim" },
}
