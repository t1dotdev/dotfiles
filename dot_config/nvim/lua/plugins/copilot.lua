return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	build = ":Copilot auth",
	event = "BufReadPost",
	opts = {
		suggestion = {
			enabled = false,
			auto_trigger = false,
		},
		panel = { enabled = false },
		filetypes = {
			markdown = true,
			help = true,
		},
		copilot_model = "gpt-4o-copilot",
	},
}
