---@diagnostic disable: undefined-global
local util = require('lspctl.lsp.util')

---
--- get all installed LSP servers
--- インストール済みのLSPサーバーを取得
---
--- @return lsptuple lspclient object definition list
---
return function()
  local success, lspconfig = pcall(require, 'lspconfig')
  if not success then
    return {}
  end

  -- インストール済みLSPの一覧を取得する
  local installed_servers = {}
  for name, conf in pairs(lspconfig) do
    --local attached_buffer = client.attached_buffers[bn]
    installed_servers[name] = util.get_init_client(name)
  end

  return {
    clients = installed_servers,
    categories = {},
  }
end
