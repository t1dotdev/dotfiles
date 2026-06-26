-- vim-herdr-navigation: seamless <C-h/j/k/l> across nvim splits and herdr panes,
-- falling back to tmux (vim-tmux-navigator) or plain wincmd when not in herdr.
-- The plugin's editor/nvim.lua sets the normal-mode keymaps itself, so we load
-- eagerly (no `keys`) and disable vim-tmux-navigator's own mappings.
return {
	"paulbkim-dev/vim-herdr-navigation",
	dependencies = { "christoomey/vim-tmux-navigator" },
	lazy = false,
	init = function()
		vim.g.tmux_navigator_no_mappings = 1
	end,
	config = function()
		dofile(vim.fn.stdpath("data") .. "/lazy/vim-herdr-navigation/editor/nvim.lua")
	end,
}
