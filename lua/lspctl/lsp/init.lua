local util = require('lspctl.lsp.util')

local M = {
  clients = nil,
  categories = {},

  lspconfig = require('lspctl.lsp.lspconfig'),
  mason = require('lspctl.lsp.mason'),
}

--- @class get_client_opts
--- @field manager "lspconfig"|"mason"

---
--- get_all_clients - クライアント取得
---
--- @param opt get_client_opts
---
--- @return lspclient[] lspclient object definition list
---
M.get_all_clients = function(opt)
  opt = opt or { manager = 'lspconfig' }
  if not M.clients then
    -- get installed LSP server list from each configs
    -- インストール済みサーバー一覧を取得
    if opt.manager == 'lspconfig' then
      local data = M.lspconfig()
      M.clients = data.clients
      M.categories = data.categories
    elseif opt.manager == 'mason' then
      local data = M.mason()
      M.clients = data.clients
      M.categories = data.categories
    end
  end

  -- update active servers / アクティブなサーバーを更新
  local active_clients = util.get_clients()
  for name, client in pairs(active_clients) do
    M.clients[name] = client
  end

  return M.clients
end

return M
