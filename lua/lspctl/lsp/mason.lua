---@diagnostic disable: undefined-global
local util = require('lspctl.lsp.util')

---
--- get all installed LSP servers
--- インストール済みのLSPサーバーを取得
---
--- @return lsptuple lspclient object definition list
---
return function()
  local success, registry = pcall(require, 'mason-registry')
  if not success then
    return {}
  end
  local installed_packages = registry.get_installed_packages()

  -- インストール済みLSPの一覧を取得する
  local installed_servers = {}
  local installed_categories = {}
  for _, package in ipairs(installed_packages) do
    local name = package.name
    --local attached_buffer = client.attached_buffers[bn]
    installed_servers[name] = util.get_init_client(name)
    installed_categories[name] = package.categories
  end

  return {
    clients = installed_servers,
    categories = installed_categories,
  }
end
