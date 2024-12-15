return {
	-- {
	-- 	"navarasu/onedark.nvim",
	-- 	opts = {
	-- 		transparent = true,
	-- 		style = "deep",
	-- 	},
	-- },
	{
		"sainnhe/sonokai",
		priority = 1000,
		config = function()
			vim.g.sonokai_transparent_background = "1"
			vim.g.sonokai_enable_italic = "1"
			vim.g.sonokai_style = "andromeda"
			vim.cmd.colorscheme("sonokai")
		end,
	},
	-- {
	-- 	"Mofiqul/dracula.nvim",
	-- 	opts = {
	-- 		transparent_bg = true,
	-- 	},
	-- },
	-- {
	-- 	"olimorris/onedarkpro.nvim",
	-- 	config = function()
	-- 		require("onedarkpro").setup({
	-- 			options = {
	-- 				transparency = true,
	-- 			},
	-- 		})
	-- 	end,
	-- 	-- opts = {
	-- 	-- 	transparency = true,
	-- 	-- },
	-- },
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "sonokai",
			-- colorscheme = "onedark_dark",
			-- colorscheme = "onedark",
			-- colorscheme = "dracula",
		},
	},
}
