---@diagnostic disable: undefined-global
local default_keymap = require("lspctl.config.keymap")
local actions = require("lspctl.actions")
local lspctlcore = require("lspctl.lsp")

local plugin_name = "lspctl"
local default_lsp_manager = "lspconfig"

---@class lspctl_config
---@field keymap lspctl_keymap
---@field manager "lspconfig"|"mason"

---table
---@class lspctl
---@field keymap lspctl_keymap
local M = {
  keymap = default_keymap,
  manager = default_lsp_manager,
  actions = actions,
}


---
---setup - setup with initialize
---
---@param opt lspctl_config|nil config
---
M.setup = function(opt)
  vim.api.nvim_create_user_command('Lspctl', function()
    M.run();
  end, {})

  -- set config
  M.keymap = opt and opt.keymap or default_keymap
  M.manager = opt and opt.manager or default_lsp_manager
end

M.run = function()
  local clients = lspctlcore.get_all_clients({ manager = M.manager })
  M.render(clients)
end

---
---render - 描画
---
---@param clients lspclient[]
---
M.render = function(clients)
  local Popup = require("nui.popup")
  local Layout = require("nui.layout")
  local EM = require("lspctl.ext.menu")

  local popup_head = Popup({
    border = {
      style = "double",
    },
  })

  local lines = {}
  for _, v in pairs(clients) do
    local m = EM.item(v.name, { attached = v.attached })
    table.insert(lines, m)
  end

  if #lines < 1 then
    table.insert(lines, EM.item("No Lsp"))
  end

  local menu_options = {
    position = "50%",
    border = {
      style = "single",
      text = {
        top = "[LspController]",
        top_align = "center",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:Normal",
    },
    keymap = {
    },
  }

  local menu = EM(menu_options, {
    lines = lines,
    on_close = function()
      print("Menu Closed!")
    end,
    on_submit = function(item)
      print("Menu Submitted: ", item.text)
    end,
  })

  M.actions.clients = clients

  local popup_body = Popup({
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
    },
  })
  local layout = Layout(
    {
      position = "50%",
      size = {
        width = "60%",
        height = "50%",
      },
    },
    Layout.Box({
      Layout.Box(popup_head, { size = "10%" }),
      Layout.Box(menu, { size = "90%" }),
    }, {
      dir = "col",
    })
  )

  popup_body:map("n", "q", function()
    layout:close()
    layout:unmount()
  end, {})
  layout:mount()

  local gb = vim.api.nvim_get_current_buf()
  vim.api.nvim_set_option_value("filetype", plugin_name, { buf = gb })

  local opt = { buffer = gb }
  menu:map("n", M.keymap.start, M.actions.start, opt)
  menu:map("n", M.keymap.stop, M.actions.stop, opt)
  menu:map("n", M.keymap.restart, M.actions.restart, opt)
end

return M
