local Explosion  = {x = 0, y = 0, scale = 1, frameActive = 1, explosionTimer = 0}
local id = 0
require("main")


Explosion.class = 'Explosion'
--Create Explosion
--@param o args for instance
--@return an instance of Explosion
function Explosion:new(o)
  o = o or {}
  setmetatable(o, Explosion)
  self.__index = self
  id = id + 1
  o.id = id
  return o
end
function Explosion:getId()
  return self.id
end
return Explosion

