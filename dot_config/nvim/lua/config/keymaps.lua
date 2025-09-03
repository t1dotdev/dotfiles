local map = vim.keymap.set

-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Also add for terminal mode to navigate out of terminal
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Go to Left Window from Terminal" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Go to Lower Window from Terminal" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Go to Upper Window from Terminal" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Go to Right Window from Terminal" })

-- lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- windows
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })

-- Don't yank
map({ "n", "v" }, "<Leader>p", '"0p')
map({ "n", "v" }, "<Leader>P", '"0P')
map({ "n", "v" }, "<Leader>c", '"_c')
map({ "n", "v" }, "<Leader>C", '"_C')
map({ "n", "v" }, "<Leader>d", '"_d')
map({ "n", "v" }, "<Leader>D", '"_D')

-- Better navigation
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-d>", "<C-d>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- buffer indent
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line down" })

-- select all
map("n", "<C-a>", "gg<S-v>G")

-- map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- Better search and replace
map({ "n", "x" }, "gw", "*N", { desc = "Search Word Under Cursor" })
map("n", "<leader>sr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace Word Under Cursor" })

-- Quick save and quit
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save File" })
map("n", "<leader>q", "<cmd>qa<cr>", { desc = "Quit All" })

-- Quick fix and location list
map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xf", "<cmd>copen<cr>", { desc = "Quickfix List" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- Better paste
map("x", "<leader>p", [["_dP]], { desc = "Paste Without Yanking" })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })
