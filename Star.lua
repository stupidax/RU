local Star  = {x = 0, y = 0, speed = 1, scale = 1}
local id = 0
require("main")


Star.class = 'Star'
--Create Star
--@param o args for instance
--@return an instance of Star
function Star:new(o)
  o = o or {}
  setmetatable(o, Star)
  self.__index = self
  id = id + 1
  o.id = id
  return o
end
function Star:getId()
  return self.id
end
function Star:getPosition()
  local position = {}
    position.x = self.x
    position[2] = self.y
    return position
end

return Star

