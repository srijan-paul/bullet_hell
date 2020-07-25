local World = Class('World')

local TIME_STEP = 0.016

function World:init()
    self.drawables = {}
    self.entities = {}
    self.time_elapsed = 0
end

function World:draw()

end


function World:update(dt)
    self.time_elapsed = self.time_elapsed + dt
    for i = 1, #self.entities do 
        self.entities[i]:update(dt)
    end
end


function World:_physics_process(dt)
    
end

return World