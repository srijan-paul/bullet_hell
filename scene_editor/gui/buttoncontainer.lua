local imgbtn = require 'scene_editor.gui.button'
local ButtonContainer = Class('ButtonContainer')

local default_opts = {rows = 1, cols = 1, padding = {1, 1}}

local BTN_DEFAULTS = {
  width = 32,
  height = 32,
  image = Resource.UI.BtnPlaceHolder,
  type = 'image'
}

function ButtonContainer:init(x, y, properties)
  self.x, self.y = x, y

  for k, _ in pairs(default_opts) do
    self[k] = properties[k] and properties[k] or default_opts[k]
  end

  self.btn_props = properties.button or BTN_DEFAULTS

  local tx, ty = self.x, self.y
  self.buttons = {}
  for i = 1, self.rows do self.buttons[i] = {} end

  self.event_listeners = {}
end

-- ? possible optimization
function ButtonContainer:draw()
  for r = 1, #self.buttons do
    for c = 1, #self.buttons[r] do
      self.buttons[r][c]:draw()
      local b = self.buttons[r][c]
      lg.rectangle('line', b.x, b.y, b.w, b.h)
    end
  end
end

function ButtonContainer:add_button(row, col, props)
  if (row < 1 or row > self.rows) or (col < 1 or col > self.cols) then return end
  local x = self.x + (row - 1) * self.btn_props.width
  local y = self.x + (col - 1) * self.btn_props.height
  props.width = self.btn_props.width
  props.height = self.btn_props.height
  local btn = imgbtn(x, y, props)
  self.buttons[row][col] = btn
  btn.container = self
end

-- ? possible optimization
function ButtonContainer:check_click(mx, my)
  for i = 1, #self.buttons do
    for j = 1, #self.buttons[i] do
      if self.buttons[i][j]:check_click(mx, my) then return true end
    end
  end
  return false
end

function ButtonContainer:onclick(r, c, fn)
  if self.buttons[r][c] then self.buttons[r][c]:onclick(fn) end
end

function ButtonContainer:catch(event, ...)
  if self.event_listeners[event] then self.event_listeners[event](...) end
end

return ButtonContainer
