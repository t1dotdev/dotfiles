-- Nvim sets 'background' from the terminal's color before this file runs, and
-- chadrc picks the theme from it, so each value gets its own compiled cache.
local function set_base46_cache()
	vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46_cache/" .. vim.o.background .. "/"
end
set_base46_cache()

-- Load options first
require("config.options")
require("config.diagnostics")
-- Load modular autocmd files
require("config.commands")
require("config.autocmds")
require("config.autocmds.entrypoint")
require("config.autocmds.lsp-attach")
require("config.lazy")
require("config.keymaps")

-- ponytail: saving chadrc recompiles the active background only; delete
-- base46_cache to refresh both.
local function load_theme()
	if vim.fn.isdirectory(vim.g.base46_cache) == 0 then
		require("base46").compile()
	end
	for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
		dofile(vim.g.base46_cache .. v)
	end
	-- Undercurl diagnostics; `:hi X gui=undercurl` keeps the theme's colors.
	for _, s in ipairs({ "Error", "Warn", "Info", "Hint" }) do
		vim.cmd.highlight("DiagnosticUnderline" .. s .. " gui=undercurl")
	end
end
load_theme()

-- Fires when the terminal switches light/dark (DEC 2031) and on `<leader>ub`.
vim.api.nvim_create_autocmd("OptionSet", {
	pattern = "background",
	callback = function()
		for _, mod in ipairs({ "nvconfig", "chadrc", "base46" }) do
			require("plenary.reload").reload_module(mod)
		end
		set_base46_cache()
		-- Plugins derive colors with `default = true`, which can't overwrite, so
		-- clear for ColorScheme to rebuild them. Links stay valid across themes and
		-- some (copilot, blink) are set once, so keep those.
		local links = {}
		for name, hl in pairs(vim.api.nvim_get_hl(0, {})) do
			links[name] = hl.link and hl or nil
		end
		vim.cmd.highlight("clear")
		load_theme()
		for name, hl in pairs(links) do
			vim.api.nvim_set_hl(0, name, hl)
		end
		vim.api.nvim_exec_autocmds("ColorScheme", { modeline = false })
	end,
})

-- base46's cache sets 'background', so Nvim treats it as user-set and removes
-- its own OSC 11 listener at VimEnter. Keep live detection with this one.
vim.api.nvim_create_autocmd("TermResponse", {
	nested = true, -- let OptionSet fire
	callback = function(ev)
		local r, g, b = ev.data.sequence:match("^\27%]11;rgba?:(%x+)/(%x+)/(%x+)")
		if r then
			local function channel(hex)
				return tonumber(hex, 16) / (16 ^ #hex - 1)
			end
			local luma = 0.299 * channel(r) + 0.587 * channel(g) + 0.114 * channel(b)
			vim.o.background = luma < 0.5 and "dark" or "light"
		end
	end,
})
