vim.api.nvim_create_user_command('LspEnable', function()
  local lsp_configs = {}
  for _, f in pairs(vim.api.nvim_get_runtime_file('lsp/*.lua', true)) do
    local server_name = vim.fn.fnamemodify(f, ':t:r')
    table.insert(lsp_configs, server_name)
  end

  -- Merge blink.cmp completion capabilities into every server (snippets,
  -- auto-import on accept, etc). Set before enable so servers start with them.
  local ok, blink = pcall(require, 'blink.cmp')
  if ok then
    vim.lsp.config('*', { capabilities = blink.get_lsp_capabilities(nil, true) })
  end

  vim.lsp.enable(lsp_configs)
end, {})

-- Restart: use the builtin `:lsp restart` (nvim 0.12+).
