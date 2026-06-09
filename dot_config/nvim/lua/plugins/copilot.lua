return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	build = ":Copilot auth",
	event = "BufReadPost",
	opts = {
		suggestion = {
			enabled = true,
			auto_trigger = true,
			debounce = 75,
			keymap = {
				accept = false, -- accepted via blink.cmp's <Tab> (see blink-cmp.lua)
				accept_word = false,
				accept_line = false,
				next = "<M-]>",
				prev = "<M-[>",
				dismiss = "<C-]>",
			},
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
	},
}
