-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- import your plugins
		{ import = "plugins" },
		"nvim-lua/plenary.nvim",
		{ "nvim-tree/nvim-web-devicons", lazy = true },

		{
			"nvchad/ui",
			config = function()
				require("nvchad")
			end,
		},

		{
			"nvchad/base46",
			lazy = false,
			priority = 1000,
			config = function()
				local ok, base46 = pcall(require, "base46")
				if ok then
					base46.load_all_highlights()
				end
			end,
		},
		"nvchad/volt",
	},
	defaults = {
		lazy = true,
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "nvchad" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
	ui = {
		border = "rounded",
		-- Set custom border highlights
		backdrop = 100,
	},
})
