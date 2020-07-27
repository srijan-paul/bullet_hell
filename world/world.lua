local World = Class('World')

local TIME_STEP = 0.016

function World:init(width, height)
    self.width = width or 200
    self.height = height or 200
    self.drawables = {}
    self.entities = {}
    self.time_elapsed = 0
end

function World:draw()
    for i = 1, #self.drawables do
        self.drawables[i]:draw()
    end
    love.graphics.rectangle('line', 0, 0, self.width, self.height)
end


function World:update(dt)
    self.time_elapsed = self.time_elapsed + dt
    for i = 1, #self.entities do
        self.entities[i]:update(dt)
    end
    while self.time_elapsed >= TIME_STEP do
        self:_physics_process(self.time_elapsed)
        self.time_elapsed = self.time_elapsed - TIME_STEP
    end
end


function World:_physics_process(dt)
    for i = 1, #self.entities do 
        local e = self.entities[i]
        e:_physics_process(dt)
    end
end


function World:add_drawable(d)
    -- TODO: after depth sorting, change this logic
    --  to insert in sorted array
    self.drawables[#self.drawables + 1] = d
end

function World:add_ent(e)
    self.entities[#self.entities + 1] = e
end

return World