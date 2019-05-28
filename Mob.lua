local Mob  = {x = 0, y = 0, speed = 1, life = 3, direction = 2, frameActive = 2, scale = 0.1, directionTimer = 0, distance = 0, directionChange = true, mobHit = false}
local id = 0
require("main")

Mob.class = 'Mob'
--Create Mob
--@param o args for instance
--@return an instance of Mob
function Mob:new(o)
  o = o or {}
  setmetatable(o, Mob)
  self.__index = self
  id = id + 1
  o.id = id
  return o
end
function Mob:getId()
  return self.id
end
function Mob:getPosition()
  local position = {}
    position.x = self.x
    position.y = self.y
    return position
end
function Mob:getLife()
  return self.life
end
function Mob:lifeDown(damage)
  self.life = self.life - damage
end
return Mob

