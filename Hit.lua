local Hit  = {x = 0, y = 0, scale = 1, frameActive = 1, hitTimer = 0}
local id = 0
require("main")


Hit.class = 'Hit'
--Create Hit
--@param o args for instance
--@return an instance of Hit
function Hit:new(o)
  o = o or {}
  setmetatable(o, Hit)
  self.__index = self
  id = id + 1
  o.id = id
  return o
end
function Hit:getId()
  return self.id
end
return Hit

