return {
	"vyfor/cord.nvim",
	build = "./build",
	event = "VeryLazy",
	opts = {
		editor = {
			tooltip = "Neovim | tmux | no mouse",
		},

		display = {
			swap_icons = true,
			swap_fields = true,
			theme = "catppuccin",
			flavor = "accent",
		},
		text = {
			-- workspace = function(opts)
			-- 	return "Working on " .. opts.workspace .. " 🚀"
			-- end,
			workspace = "🚀 In ${workspace}",
			editing = "Vibing ${filename} ✨",
			terminal = "Running ${name} 🖥️",
		},
		variables = true, -- Enable string templates
		buttons = {
			{
				label = function(opts)
					return opts.repo_url and "View Repository" or "Website"
				end,
				url = function(opts)
					return opts.repo_url or "https://example.com"
				end,
			},
		},
		idle = {
			enabled = false,
			details = "Vibing ✨",
		},
	},
}
