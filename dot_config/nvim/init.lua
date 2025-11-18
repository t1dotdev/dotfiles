vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46_cache/"

-- Load options first
require("config.options")
-- Load modular autocmd files
require("config.commands")
require("config.autocmds")
require("config.autocmds.entrypoint")
require("config.autocmds.lsp-attach")
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
