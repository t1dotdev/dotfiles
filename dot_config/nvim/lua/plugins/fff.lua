return {
	"dmtrKovalenko/fff.nvim",
	build = "cargo build --release",
	-- or if you are using nixos
	-- build = "nix run .#release",
	opts = { -- (optional)
		prompt = " ➜ ",
		max_threads = 8,
		debug = {
			enabled = false, -- disable debug mode to avoid warning messages
			show_scores = false, -- to help us optimize the scoring system, feel free to share your scores!
		},
		layout = {
			prompt_position = "top", -- or 'top'
		},
	},
	-- No need to lazy-load with lazy.nvim.
	-- This plugin initializes itself lazily.
	lazy = false,
	keys = {
		{
			"<leader><leader>", -- try it if you didn't it is a banger keybinding for a picker
			function()
				require("fff").find_files()
			end,
			desc = "FFFind files",
		},
	},
}
