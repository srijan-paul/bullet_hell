local Timer = Class('Timer')

function Timer:init(owner, tick_time, tickfn)
  self.owner = owner
  -- how often the AI "ticks" or updates
  self.tick_time = tick_time or 0.25
  -- time passed since the last tick
  self.accumulated_time = 0
  self.tick = tickfn or self.tick
end

function Timer:update(dt)
  self.accumulated_time = self.accumulated_time + dt
  if self.accumulated_time >= self.tick_time then
    self:tick()
    self.accumulated_time = 0
  end
end

function Timer:tick()

end

function Timer:delete()
  self.owner = nil
end

return Timer
