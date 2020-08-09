local PManager = Class('PManager')

local tremove, tinsert = table.remove, table.insert

function PManager:init() self.systems = {} end

function PManager:add_system(sys)
    sys._gc_tag = false
    tinsert(self.systems, sys)
end

function PManager:remove_system(sys)
    sys._gc_tag = true
end

function PManager:draw()
    sugar.foreach(self.systems, function(sys) sys:draw() end)
end

function PManager:update(dt)
    for i = #self.systems, 1, -1 do
        local sys = self.systems[i]
        sys:update(dt)
        if sys._gc_tag then
            tremove(self.systems, i)
            sys:delete()
        end
    end
end

return PManager
