---
---@class lspctl_keymap lspctl object definition
---@field info string keymap for info
---@field start string keymap for LspStart
---@field stop string keymap for LspStop
---@field restart string keymap for LspRestart
---@field close string keymap for close `lspctl` window
---
local lspctl_keymap = {
  info = "h",
  start = "s",
  stop = "x",
  restart = "r",
  close = "q",
}

return lspctl_keymap
