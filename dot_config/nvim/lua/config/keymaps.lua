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

-- center
map({ "n", "x" }, "j", "v:count == 0 ? 'gjzz' : 'jzz'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gjzz' : 'jzz'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gkzz' : 'kzz'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gkzz' : 'kzz'", { desc = "Up", expr = true, silent = true })
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-d>", "<C-d>zz")

-- buffer indent
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line down" })

-- select all
map("n", "<C-a>", "gg<S-v>G")

-- split
-- map("n", "<leader>|")
-- map("n", "<leader>-")
