-- Git signs for the snacks statuscolumn "git" column + hunk actions.
return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		on_attach = function(bufnr)
			local gs = require("gitsigns")
			local function map(mode, l, r, desc)
				vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
			end
			map("n", "]h", function() gs.nav_hunk("next") end, "Next Hunk")
			map("n", "[h", function() gs.nav_hunk("prev") end, "Prev Hunk")
			map({ "n", "x" }, "<leader>ghs", ":Gitsigns stage_hunk<cr>", "Stage Hunk")
			map({ "n", "x" }, "<leader>ghr", ":Gitsigns reset_hunk<cr>", "Reset Hunk")
			map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk")
			map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
			map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
			map({ "o", "x" }, "ih", ":<C-u>Gitsigns select_hunk<cr>", "Select Hunk")
		end,
	},
}
