return {
	-- {
	-- 	"sainnhe/sonokai",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.g.sonokai_transparent_background = "1"
	-- 		vim.g.sonokai_enable_italic = "1"
	-- 		vim.g.sonokai_style = "andromeda"
	-- 		vim.cmd.colorscheme("sonokai")
	-- 	end,
	-- },
	-- {
	-- 	"projekt0n/github-nvim-theme",
	-- 	config = function()
	-- 		require("github-theme").setup({
	-- 			options = {
	-- 				transparent = true,
	-- 			},
	-- 		})
	--
	-- 		vim.cmd("colorscheme github_dark_default")
	-- 	end,
	-- },
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			require("tokyonight").setup({
				style = "night",
				transparent = true,
			})
		end,
	},
}
