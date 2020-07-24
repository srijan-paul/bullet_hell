local util = {}


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

util.stack = stack

-- util

function util.hex_to_color(hexcode)
    local start = 0
    if hexcode:sub(1, 1) == '#' then start = 1 end
    local r = util.parseHex(hexcode:sub(start + 1, start + 2)) / 255
    local g = util.parseHex(hexcode:sub(start + 3, start + 4)) / 255
    local b = util.parseHex(hexcode:sub(start + 5, start + 6)) / 255
    return r, g, b
end

function util.parse_hex(hex)
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

function util.push_translate_rotate(x, y, r)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r)
    love.graphics.translate(-x, -y)
end

function util.push_rotate(r)
    love.graphics.push()
    love.graphics.rotate(r)
end

function util.push_translate(x, y)
    love.graphics.push()
    love.graphics.translate(x, y)
end

function util.pop() love.graphics.pop() end

function util.foreach(arr, func) for i = 1, #arr do func(arr[i]) end end

function util.sum(t)
    local sum = 0
    for _, v in pairs(t) do sum = sum + v end

    return sum
end

function util.sign(num)
    if num > 0 then return 1 end
    if num < 0 then return -1 end
    return num
end

function util.lerp(a, b, x) return a + (b - a) * x end

function util.index_of(t, v)
    for i = 1, #t do if t[i] == v then return i end end
    return -1
end

function util.remove(t, v)
    local index = util.index_of(t, v)
    table.remove(t, index)
end

function util.clamp(value, min, max)
    if max and value > max then return max end
    if value < min then return min end
    return value
end

function util.contains(t, v)
    for i = 1, #t do 
        if t[i] == v then return true end 
    end
    return false
end


function util.is_digit(d)
    local ascii = string.byte(d)
    return ascii >= 48 and ascii <= 57
end

function util.is_alpha(char)
    local ascii = string.byte(char)
    return (ascii >= 65 and ascii <= 90) or (ascii >= 97 and ascii <= 122)
end

function util.is_alnum(char)
    return util.is_alpha(char) or util.is_digit(char)
end


return util