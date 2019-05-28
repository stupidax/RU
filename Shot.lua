local Shot  = {x = 0, y = 0, speed = 1, xScale = 1, yScale = 1, hit = false, pos = 22}
local id = 0
require("main")


Shot.class = 'Shot'
--Create Shot
--@param o args for instance
--@return an instance of Shot
function Shot:new(o)
  o = o or {}
  setmetatable(o, Shot)
  self.__index = self
  id = id + 1
  o.id = id
  return o
end
function Shot:getId()
  return self.id
end
function Shot:addShot(firePosition)

end
function Shot:getPosition()
  local position = {}
    position.x = self.x
    position.y = self.y
    return position
end

return Shot

