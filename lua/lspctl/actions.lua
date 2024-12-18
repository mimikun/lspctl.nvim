---@diagnostic disable: undefined-global
local M = {
  clients = {}
}

local function get_name()
  return vim.fn["getline"](".")
end

function M:start()
  local name = get_name()
  if M.clients[name] then
    vim.print("[lspctl]start: " .. name)
    vim.lsp.start_client(name)
  end
end

function M:stop()
  local name = get_name()
  local client = M.clients[name]
  if client then
    vim.print("[lspctl]stop: " .. name)
    vim.lsp.stop_client(client.id)
  end
end

function M:restart()
  vim.print("[lspctl]restart: " .. name)
  local name = get_name()
  local client = M.clients[name]
  if client then
    vim.lsp.stop_client(client.id)
  end
  vim.lsp.start_client(name)
end

return M
