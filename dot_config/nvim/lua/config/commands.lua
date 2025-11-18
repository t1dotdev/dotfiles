vim.api.nvim_create_user_command('LspEnable', function()
  local lsp_configs = {}
  for _, f in pairs(vim.api.nvim_get_runtime_file('lsp/*.lua', true)) do
    local server_name = vim.fn.fnamemodify(f, ':t:r')
    table.insert(lsp_configs, server_name)
  end
  vim.lsp.enable(lsp_configs)
end, {})

vim.api.nvim_create_user_command('LspRestart', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients { bufnr = bufnr }
  vim.lsp.stop_client(clients, true)

  local timer = vim.uv.new_timer()

  timer:start(500, 0, function()
    for _, _client in ipairs(clients) do
      vim.schedule_wrap(function(client)
        vim.lsp.enable(client.name)

        vim.cmd ':noautocmd write'
        vim.cmd ':edit'
      end)(_client)
    end
  end)
end, {})
