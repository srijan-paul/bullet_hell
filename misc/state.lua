local State = {}

function State:init(name, switchfn)
    local new_state = {}
    new_state.name = name
    self.__index = self
    setmetatable(new_state, State)
    if switchfn then new_state.switch = switchfn end
    return new_state
end

function State:update(ent, dt)
    -- body
end

function State:switch(ent, dt)
    -- body
end

return
    setmetatable(State, {__call = function(name) return State:init(name) end})
