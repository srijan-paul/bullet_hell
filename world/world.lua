local World = Class('World')

local TIME_STEP = 0.016

function World:init()
    self.drawables = {}
    self.entities = {}
    self.time_elapsed = 0
end

function World:draw()
    for i = 1, #self.drawables do
        self.drawables[i]:draw()
    end
end


function World:update(dt)
    self.time_elapsed = self.time_elapsed + dt
    for i = 1, #self.entities do 
        self.entities[i]:update(dt)
    end
    while self.time_lag >= TIME_STEP do
        self:_physics_process(dt)
        self.time_lag = self.time_lag - TIME_STEP
    end
end


function World:_physics_process(dt)

end

return World