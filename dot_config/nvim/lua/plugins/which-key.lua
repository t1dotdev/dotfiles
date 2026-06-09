return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "modern",
		delay = 200,
		-- match purple float borders (#875fff)
		win = {
			border = "rounded",
		},
		spec = {
			{ "<leader>a", group = "AI/Claude", icon = "󰚩" },
			{ "<leader>b", group = "Buffer", icon = "" },
			{ "<leader>c", group = "Code", icon = "" },
			{ "<leader>f", group = "Find/File", icon = "" },
			{ "<leader>g", group = "Git", icon = "" },
			{ "<leader>n", group = "Notifications", icon = "" },
			{ "<leader>q", group = "Session/Quit", icon = "" },
			{ "<leader>r", group = "Refactor/Rename", icon = "" },
			{ "<leader>s", group = "Search", icon = "" },
			{ "<leader>u", group = "UI/Toggle", icon = "" },
			{ "<leader>x", group = "Diagnostics/Trouble", icon = "" },
			{ "<leader>p", group = "Paste/Put" },
		},
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
}
