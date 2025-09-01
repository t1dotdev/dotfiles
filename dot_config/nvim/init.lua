vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46_cache/"

-- Load options first
require("config.options")

require("config.lazy")
require("config.keymaps")

-- Check if base46 cache exists before loading
if vim.fn.isdirectory(vim.g.base46_cache) == 1 then
	for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
		dofile(vim.g.base46_cache .. v)
	end
else
	-- Generate base46 cache if it doesn't exist
	vim.schedule(function()
		require("base46").load_all_highlights()
	end)
end

-- vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { bg = "NONE", fg = "#875fff" })
-- vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { bg = "NONE", fg = "#875fff" })
-- vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelpBorder", { bg = "NONE", fg = "#875fff" })

-- vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE", fg = "#888888" })
-- vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE", fg = "#ffffff" })

-- Set blink.cmp border color
