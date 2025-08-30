return {
	{
		"NvChad/base46",
		build = function()
			require("base46").load_all_highlights()
		end,
		config = function()
			-- Create custom theme directory if it doesn't exist
			local theme_dir = vim.fn.stdpath("config") .. "/lua/themes"
			vim.fn.mkdir(theme_dir, "p")
		end,
	},
}

