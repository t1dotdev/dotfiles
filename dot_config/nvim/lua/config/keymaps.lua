local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("n", "x", '"_x')
-- Shift + h to move to top of the screen
-- keymap.set("n", "<S-h>", "H")
-- keymap.set("n", "<S-l>", "L")

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Save file and quit
keymap.set("n", "<Leader>w", ":update<Return>", opts)
keymap.set("n", "<Leader>q", ":quit<Return>", opts)
keymap.set("n", "<Leader>Q", ":qa<Return>", opts)

-- File explorer with NvimTree
keymap.set("n", "<Leader>f", ":NvimTreeFindFile<Return>", opts)
keymap.set("n", "<Leader>e", ":NvimTreeToggle<Return>", opts)

-- Tabs
keymap.set("n", "te", ":tabedit")
keymap.set("n", "<Tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-Tab>", ":tabprev<Return>", opts)
keymap.set("n", "tw", ":tabclose<Return>", opts)

-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)

-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Resize window
-- keymap.set("n", "<C-h>", "<C-w><")
-- keymap.set("n", "<C-l>", "<C-w>>")
-- keymap.set("n", "<C-k>", "<C-w>+")
-- keymap.set("n", "<C-j>", "<C-w>-")
--
-- Move lines
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "<C-d>", "<C-d>zz")

-- vim.api.nvim_set_keymap("n", "//<CR>", 'copilot#Accept("<Tab>")', { silent = true, expr = true })
--

keymap.set("n", "<leader>r", require("telescope").extensions.flutter.commands, { desc = "Open command Flutter" })
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

-- Diagnostics
-- keymap.set("n", "<C-j>", function()
-- 	vim.diagnostic.goto_next()
-- end, opts)
