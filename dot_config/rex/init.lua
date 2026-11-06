-- Cmd+L: lazygit in a floating pane, in the focused terminal's directory.
rex.action{
  name  = "lazygit",
  title = "Open lazygit",
  run   = function(ctx)
    local pwd = rex.block.call("com.superlogical.terminal", "pwd", { block_id = ctx.block_id })
    local cwd = pwd and pwd.pwd and pwd.pwd
      :gsub("^file://[^/]*", "")
      :gsub("%%(%x%x)", function(h) return string.char(tonumber(h, 16)) end)
    local layer, err = rex.session.new_layer{
      bounds = { 0.05, 0.05, 0.9, 0.9 },
      focus  = true,
      layout = rex.layout.block{
        flavor  = "com.superlogical.terminal.shell",
        -- zsh4humans skips .zshrc for non-interactive zsh, so Homebrew isn't on PATH
        options = { command = { "lazygit" }, path_prepend = { "/opt/homebrew/bin" }, cwd = cwd },
      },
    }
    if err ~= nil then error(err, 0) end
    return layer
  end,
}

rex.bind("cmd+l", "lazygit")
rex.bind("cmd+g", "client.find.next")
