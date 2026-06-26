return {
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	config = true,
	keys = {
		{ "<leader>a", nil, desc = "AI/Claude Code" },
		{ "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
		{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
		{ "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
		{ "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
		{ "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
		{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
		{ "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
		{
			"<leader>as",
			"<cmd>ClaudeCodeTreeAdd<cr>",
			desc = "Add file",
			ft = { "NvimTree", "neo-tree", "oil", "minifiles" },
		},
		-- Diff management
		{ "ga", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
		{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
	},
	opts = {
		terminal_cmd = "claude --ide",
		terminal = {
			provider = "external",
			provider_opts = {
				-- Pass IDE connection env (CLAUDE_CODE_SSE_PORT, ENABLE_IDE_INTEGRATION, ...)
				-- into the new pane via `-e`. `tmux split-window` spawns in the tmux server
				-- env, so jobstart's env never reaches the pane — without this, claude falls
				-- back to lockfile auto-discovery and fails to connect when more than one
				-- nvim IDE lockfile exists.
				external_terminal_cmd = function(cmd, env)
					local args = { "tmux", "split-window", "-h", "-p", "40" }
					for k, v in pairs(env or {}) do
						table.insert(args, "-e")
						table.insert(args, k .. "=" .. v)
					end
					table.insert(args, cmd)
					return args
				end,
			},
		},
	},
}
