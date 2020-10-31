local PlayerInput = Class('PlayerInput')

function PlayerInput:init(player)
  self.owner = player -- instance of the player class
  self.movedir = Vec2(0, 0) -- resulting direction of movement from all the inputs
  self.keypressed = false -- whether a relevant input key is pressed
end

function PlayerInput:update(dt)

  if keyboard.isDown('w') then
    self.movedir.y = -1
    self.keypressed = true
  elseif keyboard.isDown('s') then
    self.movedir.y = 1
    self.keypressed = true
  else
    self.movedir.y = 0
  end

  if keyboard.isDown('a') then
    self.movedir.x = -1
  elseif keyboard.isDown('d') then
    self.movedir.x = 1
  else
    self.movedir.x = 0
  end
end

return PlayerInput
