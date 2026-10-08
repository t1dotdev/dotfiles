local augroup = vim.api.nvim_create_augroup("lsp-attach", { clear = true })

local DISABLE_FILETYPES = {
	"DiffviewFileHistory",
	"DiffviewFiles",
	"checkhealth",
	"diff",
	"git",
	"gitcommit",
	"help",
	"lazy",
	"lspinfo",
}

-- Buffer-local LSP keymaps. gd/gr/gI/gy/gD are global Snacks pickers and
-- reference highlight/jump (]] / [[) is snacks.words — see lua/plugins/snacks.lua.
local function keymaps(bufnr, client)
	local k = function(keys, func, desc, mode)
		mode = mode or "n"
		vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
	end

	local function hover()
		-- https://neovim.io/doc/user/lsp.html#vim.lsp.buf.hover.Opts
		vim.lsp.buf.hover({
			border = "rounded",
			focusable = false,
			close_events = { "CursorMoved", "InsertEnter", "FocusLost" },
		})
	end

	k("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	k("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
	k("K", hover, "[H]over")

	-- ts_ls source actions (replaces typescript-tools.nvim commands)
	if client.name == "ts_ls" then
		local function ts_source_action(kind)
			return function()
				vim.lsp.buf.code_action({
					context = { only = { kind }, diagnostics = {} },
					apply = true,
				})
			end
		end
		k("<leader>cu", ts_source_action("source.removeUnusedImports.ts"), "Remove [U]nused imports")
		k("<leader>co", ts_source_action("source.organizeImports.ts"), "[O]rganize imports")
		k("<leader>ci", ts_source_action("source.addMissingImports.ts"), "Add m[I]ssing imports")
	end
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if not client or vim.tbl_contains(DISABLE_FILETYPES, vim.bo[event.buf].filetype) then
			return
		end
		keymaps(event.buf, client)
	end,
})

vim.api.nvim_create_user_command("LspLog", function()
	vim.cmd.edit(vim.lsp.log.get_filename())
end, { desc = "Open lsp.log file" })
