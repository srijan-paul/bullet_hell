local sugar = {}


-- stack
local stack = {}

function stack:new()
    local newStack = {_values = {}}
    self.__index = self
    return setmetatable(newStack, stack)
end

function stack:push(...)
    local args = {...}
    for i = 1, #args do 
        table.insert(self._values, args[i]) 
    end
end

function stack:pop()
    if #self._values > 0 then
        return table.remove(self._values)
    else
        return nil
    end
end

function stack:is_empty() 
    return #self._values <= 0 
end

function stack:peek() 
    return self._values[#self._values] 
end

sugar.stack = stack

-- sugar

function sugar.rgb(hexcode)
    local start = 0
    if hexcode:sub(1, 1) == '#' then start = 1 end
    local r = sugar.parseHex(hexcode:sub(start + 1, start + 2)) / 255
    local g = sugar.parseHex(hexcode:sub(start + 3, start + 4)) / 255
    local b = sugar.parseHex(hexcode:sub(start + 5, start + 6)) / 255
    return r, g, b
end

function sugar.parse_hex(hex)
    local decimal, k = 0, 1
    local stack = stack:new()

    for i = 1, #hex do stack:push(hex:sub(i, i)) end

    for i = 1, #hex do
        local char = stack:pop()
        local ascii = string.byte(char)

        if (ascii >= 97 and ascii <= 102) then
            char = 10 + ascii - 97
        elseif (ascii >= 65 and ascii <= 71) then
            char = 10 + ascii - 65
        end

        decimal = decimal + k * char
        k = k * 16
    end

    return decimal
end

function sugar.push_translate_rotate(x, y, r)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r)
    love.graphics.translate(-x, -y)
end

function sugar.push_rotate(r)
    love.graphics.push()
    love.graphics.rotate(r)
end

function sugar.push_translate(x, y)
    love.graphics.push()
    love.graphics.translate(x, y)
end

function sugar.pop() love.graphics.pop() end

function sugar.foreach(arr, func) 
    for i = 1, #arr do
        func(arr[i], i)
    end 
end

function sugar.sum(t)
    local sum = 0
    for _, v in pairs(t) do sum = sum + v end

    return sum
end

function sugar.sign(num)
    if num > 0 then return 1 end
    if num < 0 then return -1 end
    return num
end

function sugar.lerp(a, b, x) return a + (b - a) * x end

function sugar.index_of(t, v)
    for i = 1, #t do if t[i] == v then return i end end
    return -1
end

function sugar.remove(t, v)
    local index = sugar.index_of(t, v)
    table.remove(t, index)
end

function sugar.clamp(value, min, max)
    if max and value > max then return max end
    if value < min then return min end
    return value
end

function sugar.contains(t, v)
    for i = 1, #t do 
        if t[i] == v then return true end
    end
    return false
end


function sugar.is_digit(d)
    local ascii = string.byte(d)
    return ascii >= 48 and ascii <= 57
end

function sugar.is_alpha(char)
    local ascii = string.byte(char)
    return (ascii >= 65 and ascii <= 90) or (ascii >= 97 and ascii <= 122)
end

function sugar.is_alnum(char)
    return sugar.is_alpha(char) or sugar.is_digit(char)
end


return sugar