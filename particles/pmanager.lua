local PManager = Class('PManager')

local tremove, tinsert = table.remove, table.insert

function PManager:init() self.systems = {} end

function PManager:add_system(sys)
    tinsert(self.systems, sys)
end

function PManager:remove_system(sys)
    sugar.remove_val(self.systems, sys)
end

function PManager:draw()
    sugar.foreach(self.systems, function(sys) sys:draw() end)
end

function PManager:update(dt)
    sugar.foreach(self.systems, function(sys)
        sys:update(dt)
    end)
end

return PManager
