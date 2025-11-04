local vec2 = {}

vec2.__add = function(self, _tovec)
    return vec2(self.x + _tovec.x, self.y + _tovec.y)
end

vec2.__sub = function (self, _tovec)
    return vec2(self.x - _tovec.x, self.y - _tovec.y)
end

vec2.__mul = function (self, mult)
    return vec2(self.x * mult, self.y * mult)
end

setmetatable(vec2, {
    __call = function(self, x, y)
        return setmetatable({ x = x or 0, y = y or 0 }, vec2)
    end,
})

return vec2

