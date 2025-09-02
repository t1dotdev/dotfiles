-- lua/config/options.lua
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Auto format
vim.g.autoformat = true

-- Root dir detection patterns for plugins that support it
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }

-- Hide deprecation warnings
vim.g.deprecation_warnings = false

local opt = vim.opt

-- General
opt.autowrite = true -- Enable auto write
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2 -- Hide * markup for bold and italic
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.mouse = "a" -- Enable mouse mode
opt.undofile = true -- Enable persistent undo
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.timeoutlen = 300 -- Time to wait for a mapped sequence to complete
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.jumpoptions = "view" -- Better jump behavior

-- UI
opt.cursorline = true -- Enable highlighting of the current line
opt.laststatus = 3 -- Global statusline
opt.linebreak = true -- Wrap lines at convenient points
opt.list = true -- Show some invisible characters
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.ruler = false -- Disable the default ruler
opt.scrolloff = 4 -- Lines of context
opt.showmode = false -- Don't show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen" -- Keep the same relative cursor position when splitting
opt.splitright = true -- Put new windows right of current
opt.termguicolors = true -- True color support
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap

-- Fillchars for better UI
opt.fillchars = {
	fold = " ",
	foldopen = "v", -- or use "-"
	foldclose = ">",
	foldsep = " ",
	diff = "/",
	eob = " ",
}

-- Folding
opt.foldlevel = 99
opt.foldlevelstart = 99
if vim.fn.has("nvim-0.10") == 1 then
	opt.smoothscroll = true
	opt.foldmethod = "expr"
	opt.foldexpr = "nvim_treesitter#foldexpr()" -- Use treesitter for folding if you have it
	opt.foldtext = ""
else
	opt.foldmethod = "indent"
end

-- Indentation
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.smartindent = true -- Insert indents automatically
opt.tabstop = 2 -- Number of spaces tabs count for

-- Search
opt.ignorecase = true -- Ignore case
opt.smartcase = true -- Don't ignore case with capitals
opt.inccommand = "nosplit" -- Preview incremental substitute
opt.grepformat = "%f:%l:%c:%m"
if vim.fn.executable("rg") == 1 then
	opt.grepprg = "rg --vimgrep"
end

-- Format options
opt.formatoptions = "jcroqlnt" -- tcqj

-- Session options
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- Shorter messages
-- opt.shortmess:append({ W = true, I = true, c = true, C = true })

-- Spell
opt.spelllang = { "en" }

-- Wild menu
opt.wildmode = "longest:full,full" -- Command-line completion mode

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Disable some default providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- Add binaries installed by mason.nvim to path
local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH
