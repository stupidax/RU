io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")

love.window.setMode(300,200)

function love.load(arg)
if arg[#arg] == "-debug" then require("mobdebug").start() end

--require
Star = require("Star")
Shot = require("Shot")
Mob = require("Mob")
Hit = require("Hit")
Explosion = require("Explosion")

-- RNG
rng = love.math.newRandomGenerator()


--init var
allStar = {}
allLeftShot = {}
allCenterShot = {}
allRightShot = {}
allMob = {}
allHit = {}
allExplosion = {}
speed = 1
timer = 0
timer2 = 0
limitx = 0
limity = 0
leftShotTimer = 0
leftShot = false
rightShotTimer = 0
rightShot = false
centerShotTimer = 0
centerShot = false
shieldActive = false
shieldTimer = 0
shieldFrame = 1
leftReserve = 5
rightReserve = 5
leftReserveTimer = 0
rightReserveTimer = 0
reload = 500
mobCreationTimer = 0
menace = 2
aggro = 2
randMobDirection = 2
randMobTimer = 1
mobDirectionTimer = 5
mobCreation = false
mobDirectionChange = false

--init graph
bg = {}
  bg["bg1"] = love.graphics.newImage("images/bg1.png")
  bg["bg2"] = love.graphics.newImage("images/bg2.png")

board = {}
  board[1] = love.graphics.newImage("images/board.png")
  board[2] = love.graphics.newImage("images/boardLeft.png")
  board[3] = love.graphics.newImage("images/boardRight.png")
  board[4] = love.graphics.newImage("images/boardCenter.png")

shield = {}
  shield.img = love.graphics.newImage("images/shield.png")
  shield.quad = quadCreation(shield.img)

ship = {}
  ship.img = love.graphics.newImage("images/Mob0.png")
  ship.quad = quadCreation(ship.img,20,20)

explode = {}
  explode.img = love.graphics.newImage("images/explode.png")
  explode.quad = quadCreation(explode.img,20,20)
  
hitBurn = {}
  hitBurn.img = love.graphics.newImage("images/hit.png")
  hitBurn.quad = quadCreation(hitBurn.img,20,20)

end

function love.draw()
  --scaling on screen
  love.graphics.scale(10,10)
  
  --bg
  if speed < 40 then
  love.graphics.draw(bg.bg1)
else
  love.graphics.draw(bg.bg2)
  end
  
  --star
  if speed < 40 then
    love.graphics.setColor(1,1,1)
    drawStar()
  else
    love.graphics.setColor(0.1,0,0.1)
    drawStar()
    love.graphics.setColor(1,1,1)
  end
  
  if #allMob > 0 then
    drawMob(allMob)
  end


  --board
  love.graphics.draw(board[1])
  
  if leftShot == true then
    love.graphics.draw(board[2])
  end
  
  if rightShot == true then
    love.graphics.draw(board[3],15,0)
  end

  if centerShot == true then
    love.graphics.draw(board[4])
  end

  --shield
  if shieldActive == true then
    love.graphics.draw(shield.img,shield.quad[shieldFrame])
  end
  
  --shot
  drawShot(allLeftShot)
  drawShot(allCenterShot)
  drawShot(allRightShot)

  --reserve
  drawReserve(leftReserve,"left")
  drawReserve(rightReserve,"right")


  --draw Hit
  drawHit(allHit)
  
  --draw Explosion
  drawExplosion(allExplosion)

  --test 
  drawPosition(allLeftShot)
  drawPosition(allCenterShot)
  drawPosition(allRightShot)
  drawMobPosition(allMob)
  
  love.graphics.print("push space to see mob hitbox",0,0,0,0.1,0.1)
  
end

function love.update(dt)

  --create star on timer
  timer = timer + dt*10
  if timer > 5 then
    timer = timer - limitx
    limitx = love.math.random(1,7)+11
    limity = love.math.random(1,7)+4
    if limitx == 15 and limity == 8 then
      limitx = limitx + 1
    end
    if #allStar <= 15  then
    table.insert(allStar,Star:new({x=limitx,y=limity,speed=speed,scale=1}))    
    end
  end
  
  --create star on number
  if speed < 15 then
    timer2 = timer2 + dt*10
  else
    timer2 = 5
  end
  
  if #allStar <= 15 and timer2 >= 5 then
  timer2 = timer2 - 2
  rand1 = love.math.random(1,1)
    for i = 1, rand1 do
    limitx = love.math.random(1,7)+11
    limity = love.math.random(1,7)+4
    if limitx == 15 and limity == 8 then
      limitx = limitx + limity
    end
    table.insert(allStar,Star:new({x=limitx,y=limity,speed=speed,scale=1}))    
    end
  end
  
  --moving star
  if #allStar > 0 then
    moveStar(dt)
    starDestruction(allStar)
  end

  --moving shot
  if #allLeftShot > 0 then
  moveShot(allLeftShot, dt)
  shotDestruction(allLeftShot)
  end
  if #allCenterShot > 0 then
  moveShot(allCenterShot, dt)
  shotDestruction(allCenterShot)
  end
  if #allRightShot > 0 then
  moveShot(allRightShot, dt)
  shotDestruction(allRightShot)
  end

  --shield
  if speed > 20 then
    shieldActive = true
    shieldTimer = shieldTimer + dt
    if shieldTimer > 0.2 then
      shieldTimer = shieldTimer - 0.2
    end
    shieldFrame = animator(shieldFrame,5,0.2,1,shieldTimer)
  else
    shieldActive = false
  end

  --timer for reserve
  if leftReserve < 5 then
    leftReserveTimer = leftReserveTimer + dt * reload
    if leftReserveTimer > 1 then
      leftReserve = leftReserve + 1
      leftReserveTimer = leftReserveTimer - 1
    end
  else
    leftReserveTimer = 0
  end
  if rightReserve < 5 then
    rightReserveTimer = rightReserveTimer + dt * reload
    if rightReserveTimer > 1 then
      rightReserve = rightReserve + 1
      rightReserveTimer = rightReserveTimer - 1
    end
  else
    rightReserveTimer = 0
  end

  --[[--reload
  if speed > 10 then
    reload = 2
  elseif speed > 20 then
    reload = 5
  elseif speed > 40 then
    reload = 10
  else
    reload = 1
  end
  ]]
  
  --timer graphic for board
  if leftShot == true then
    leftShotTimer = leftShotTimer + dt*10
  end
  if leftShotTimer >= 1 then
    leftShot = false
  end

  if rightShot == true then
    rightShotTimer = rightShotTimer + dt*10
  end
  if rightShotTimer >= 1 then
    rightShot = false
  end

  if centerShot == true then
    centerShotTimer = centerShotTimer + dt*10
  end
  if centerShotTimer >= 1 then
    centerShot = false
  end

  --Timer Mob creation
  mobCreationTimer = mobCreationTimer + dt * menace
  if mobCreationTimer > 10 and mobCreation == false then
    mobCreationTimer = mobCreationTimer - 10
    mobCreation = true
    local randMob1 = math.random(1,30)
    local randMobTimerDirection = math.random(1,5)
    table.insert(allMob, Mob:new({x=randMob1,y=5,speed=1,life=3,direction=randMobDirection,frameActive=randMobDirection,sclae=0.1,directionTimer=0,distance=0,directionChange=true,hit=false}))
    mobCreation = false
  end
  
  --Timer Random Mob Direction
  mobDirectionTimer = mobDirectionTimer + dt * aggro
  
  --Mob direction
  mobDirectionUpdate(allMob, dt, aggro)
  mobDirection(allMob)
  
  if mobDirectionTimer > randMobTimer then
    mobDirectionTimer = 0
    randMobTimer = math.random(1,5)
    randMobDirection = math.random(1,3)
  end



  --move Mob
  moveMob(allMob, dt)
  
  --Mob scale
  mobFrameScale(allMob, dt)
  mobDistanceUpdate(allMob, dt)
  mobScale(allMob)
  
  
  
  --Mob Destruction
  mobDestruction(allMob)
  
  --Mob Life
  mobLife(allMob)

  --Shot Hit
  shotHit(allLeftShot, allMob)
  shotHit(allCenterShot, allMob)
  shotHit(allRightShot, allMob)

  --hit animation
  hitBurning(allHit, dt)
  explosionBurning(allExplosion, dt)
  
end

function love.keypressed(key)
  --quit
  if key == "escape" then
    love.event.push("quit")
  end
  
  --speed up (temp)
  if key == "up" then
    for _, star in pairs(allStar) do
      star.speed = star.speed + 1
    end
    speed = speed + 1
  end
  
  --speed down (temp)
  if key == "down" then
    for _, star in pairs(allStar) do
      star.speed = star.speed - 1
    end    
    speed = speed - 1
  end
  
  --primary shot pos 1 left
  if key == "kp1" and leftReserve > 0 then
    leftReserve = leftReserve - 1
    leftShotTimer = 0
    leftShot = true
    table.insert(allLeftShot,Shot:new({x=2,y=15,speed=1,scale=1,hit=false}))
  end
  
  --primary shot pos 2 center (double)
  if key == "kp2" and (leftReserve > 0 or rightReserve > 0) then
    centerShotTimer = 0
    centerShot = true
      if leftReserve > 0 then
      leftReserve = leftReserve - 1
      table.insert(allCenterShot,Shot:new({x=4,y=15,speed=1,scale=1,hit=false}))
      end
      if rightReserve > 0 then
      rightReserve = rightReserve - 1
      table.insert(allCenterShot,Shot:new({x=25,y=15,speed=1,scale=1,hit=false}))
      end
  end
  
  --primary shot pos 3 right
  if key == "kp3" and rightReserve > 0 then
    rightReserve = rightReserve - 1
    rightShotTimer = 0
    rightShot = true
    table.insert(allRightShot,Shot:new({x=27,y=15,speed=1,scale=1,hit=false}))
  end
  
  --hitbox debugmode
  if key == "space" and hitbox == false then
    hitbox = true
  else
    hitbox = false
  end

  
end

function drawStar()
  for _, star in pairs(allStar) do
    love.graphics.rectangle("fill",star.x,star.y,star.scale,star.scale)
  end
end

function moveStar(deltaT)
    for _, star in pairs(allStar) do
    local scaleAdjust = math.max((math.abs(star.x-15)/15),.1)
      
      if star.x > 15 and star.y > 8 then
        star.x = star.x + star.speed * deltaT
        star.y = star.y + star.speed * deltaT
        star.scale = scaleAdjust
        
      elseif star.x > 15 and star.y == 8 then
        star.x = star.x + star.speed * deltaT
        star.scale = scaleAdjust
        
      elseif star.x > 15 and star.y < 8 then
        star.x = star.x + star.speed * deltaT
        star.y = star.y - star.speed * deltaT
        star.scale = scaleAdjust
        
      elseif star.x < 15 and star.y > 8 then
        star.x = star.x - star.speed * deltaT
        star.y = star.y + star.speed * deltaT
        star.scale = scaleAdjust
        
      elseif star.x < 15 and star.y == 8 then
        star.x = star.x - star.speed * deltaT
        star.scale = scaleAdjust
        
      elseif star.x < 15 and star.y < 8 then
        star.x = star.x - star.speed * deltaT
        star.y = star.y - star.speed * deltaT
        star.scale = scaleAdjust
        
      elseif star.x == 15 and star.y > 8 then
        star.y = star.y + star.speed * deltaT
        star.scale = math.max((math.abs(star.y-10)/10),.1)
        
      elseif star.x == 15 and star.y < 8 then
        star.y = star.y - star.speed * deltaT
        star.scale = math.max((math.abs(star.y-10)/10),.1)
        
      elseif star.x < 15 and star.y < 8 then
        star.x = star.x - star.speed * deltaT
        star.y = star.y - star.speed * deltaT
        star.scale = scaleAdjust
        
      elseif star.x < 15 and star.y < 8 then
        star.x = star.x - star.speed * deltaT
        star.y = star.y - star.speed * deltaT
        star.scale = scaleAdjust
        
      elseif star.x < 15 and star.y < 8 then
        star.x = star.x - star.speed * deltaT
        star.y = star.y - star.speed * deltaT
        star.scale = scaleAdjust
        
      elseif star.x < 15 and star.y < 8 then
        star.x = star.x - star.speed * deltaT
        star.y = star.y - star.speed * deltaT
        star.scale = scaleAdjust

      end
    end
end
function starDestruction(allStar)
    for _, star in pairs(allStar) do
      if star.x < -1  or star.x > 31 or star.y < -1 or star.y > 21 then
        table.remove(allStar, _)
      end
    end
end

function moveShot(allShot,deltaT)
    for _, shot in pairs(allShot) do
      if shot.x < 15 then
        if shot.x < 4 then
          shot.x = shot.x + 3 * deltaT
          shot.y = shot.y - 12 * deltaT
          shot.scale = math.max((shot.y-5)/10,.1)
        else
          shot.x = shot.x + 15 * deltaT
          shot.y = shot.y - 12 * deltaT
          shot.scale = math.max((math.abs(shot.x-15))/10,.1)
        end
      elseif shot.x > 15 then
        if shot.x > 25 then
          shot.x = shot.x - 3 * deltaT
          shot.y = shot.y - 12 * deltaT  
          shot.scale = math.max((shot.y-5)/10,.1)
        else
          shot.x = shot.x - 15 * deltaT
          shot.y = shot.y - 12 * deltaT  
          shot.scale = 1 - math.max((25-shot.x)/10,.1)
        end
      end
    end
end

function drawShot(allShot)
  for _, shot in pairs(allShot) do
    love.graphics.setColor(0.8,0.8,0)
    love.graphics.rectangle("fill",shot.x,shot.y,shot.scale,shot.scale)
    love.graphics.setColor(1,1,1)
  end
end

function shotHit(allShot, allMob)
  if #allShot > 1 then
    if #allMob > 1 then
      for _, shot in pairs(allShot) do
        for _, mob in pairs(allMob) do
          if mob.frameActive == 1 or mob.frameActive == 2 or mob.frameActive == 3 then
            if (shot.x > mob.x-5 and shot.x < mob.x+5) and (shot.y > mob.y-5 and shot.y < mob.y+5) then
              shot.hit = true
              mob.hit = true
              print(mob.frameActive .. " sx:" .. shot.x .. " sy:" .. shot.y .. " mx:" .. mob.x .. " my:" .. mob.y .. " ms:" .. mob.scale)
            end
          elseif mob.frameActive == 4 or mob.frameActive == 5 or mob.frameActive == 6 then
            if (shot.x > mob.x-10 and shot.x < mob.x+10) and (shot.y > mob.y-10 and shot.y < mob.y+10) then
              shot.hit = true
              mob.hit = true
              print(mob.frameActive .. " sx:" .. shot.x .. " sy:" .. shot.y .. " mx:" .. mob.x .. " my:" .. mob.y .. " ms:" .. mob.scale)
            end
          elseif mob.frameActive == 7 or mob.frameActive == 8 or mob.frameActive == 9 then
            if (shot.x > mob.x-15 and shot.x < mob.x+15) and (shot.y > mob.y-15 and shot.y < mob.y+15) then
              shot.hit = true
              mob.hit = true
              print(mob.frameActive .. " sx:" .. shot.x .. " sy:" .. shot.y .. " mx:" .. mob.x .. " my:" .. mob.y .. " ms:" .. mob.scale)
            end
          elseif mob.frameActive == 10 or mob.frameActive == 11 or mob.frameActive == 12 then
            if (shot.x > mob.x-20 and shot.x < mob.x+20) and (shot.y > mob.y-20 and shot.y < mob.y+20) then
              shot.hit = true
              mob.hit = true
              print(mob.frameActive .. " sx:" .. shot.x .. " sy:" .. shot.y .. " mx:" .. mob.x .. " my:" .. mob.y .. " ms:" .. mob.scale)
            end
          else 
            print("else")
          end
        end
      end
    end
  end
end

function shotDestruction(allShot)
    for _, shot in pairs(allShot) do
      if shot.hit == true then
            table.remove(allShot, _)
      else
        if shot.x > 15 then
          if math.ceil(shot.x) == 15  or math.floor(shot.y) == 6 then
            table.remove(allShot, _)
          end
        else
          if math.floor(shot.x) == 15  or math.floor(shot.y) == 6 then
            table.remove(allShot, _)
          end
        end
      end
    end
end

function quadCreation(image, quadWidth, quadHeight)
  local quad = {}
  quadHeight = quadHeight or 20
  quadWidth = quadWidth or 30
  for ligne = 0, image:getHeight() - quadHeight, quadHeight do
    for colonne = 0, image:getWidth() - quadWidth, quadWidth do
      table.insert(quad,love.graphics.newQuad(colonne,ligne,quadWidth,quadHeight, image:getDimensions()))
    end
  end
  return quad
end

function animator(frameQuad, frameNumber, animationDuration, animationSpeed, animTimer)
  local animatedFrame = frameQuad
  local timer = animTimer
  animatedFrame = math.floor(timer / animationDuration * frameNumber) + 1 --frame active en fonction du % avancé de l'animation (+1 for table index)
  if animatedFrame > frameNumber then
    animatedFrame = frameNumber
  end
  return animatedFrame
end

function drawReserve(reserve,pos)
  love.graphics.setColor(1,1,0)
  if pos == "left" then
    for i = reserve, 0,-1 do
      if i > 0 then
    love.graphics.rectangle("fill",6+i,19,1,1)
      end
    end
  else
    for i = reserve, 0,-1 do
      if i > 0 then
    love.graphics.rectangle("fill",23-i,19,1,1)
      end
    end  
  end
  love.graphics.setColor(1,1,1)
end

function moveMob(allMob, deltaT)
  for _, mob in pairs(allMob) do
    if mob.distance < 3 then
      if mob.direction == 1 then
        mob.y = mob.y + deltaT * speed
        mob.x = mob.x - deltaT * speed
      elseif mob.direction == 2 then
        mob.y = mob.y + deltaT * speed
      elseif mob.direction == 3 then
        mob.y = mob.y + deltaT * speed
        mob.x = mob.x + deltaT * speed
      end
    elseif mob.distance > 3 and mob.distance < 5 then
      if mob.direction == 1 then
        mob.y = mob.y + deltaT * speed
        mob.x = mob.x - deltaT * speed
      elseif mob.direction == 2 then
        mob.y = mob.y + deltaT * speed
      elseif mob.direction == 3 then
        mob.y = mob.y + deltaT * speed
        mob.x = mob.x + deltaT * speed
      end
    elseif mob.distance > 5 and mob.distance <6 then
      if mob.direction == 1 then
        mob.y = mob.y + deltaT * speed
        mob.x = mob.x - deltaT * speed
      elseif mob.direction == 2 then
        mob.y = mob.y + deltaT * speed
      elseif mob.direction == 3 then
        mob.y = mob.y + deltaT * speed
        mob.x = mob.x + deltaT * speed
      end
    elseif mob.distance > 6 then
      if mob.direction == 1 then
        mob.directionChange = false
        mob.y = mob.y - deltaT * speed *2
        mob.x = mob.x - deltaT * speed *2
      elseif mob.direction == 2 then
        mob.y = mob.y - deltaT * speed *2
      elseif mob.direction == 3 then
        mob.direction = false
        mob.y = mob.y - deltaT * speed *2
        mob.x = mob.x + deltaT * speed *2
      end
    end
  end
end
function mobDistanceUpdate(allMob, deltaT)
    for _, mob in pairs(allMob) do
    mob.distance = mob.distance + math.min(deltaT * speed, 10)
  end
end
function mobDestruction(allMob)
    for _, mob in pairs(allMob) do
      if mob.life == 0 then
        table.insert(allExplosion,Explosion:new({x=mob.x,y=mob.y,scale=mob.scale,frameActive=1,explosionTimer=0}))
        table.remove(allMob, _)
        speed = speed + 1
        reload = reload + 1
      elseif mob.y > 40  or mob.x > 50 or mob.x < -20 or mob.y < -10 then
        table.remove(allMob, _)
        if speed > 1 then
          speed = speed - 1
        end
        if reload > 1 then
          reload = reload - 1
        end
      end
    end
end
function mobDirection(allMob)
  for _, mob in pairs(allMob) do
    if mob.directionChange == true then
      if mob.directionTimer > 2 then
        direction = love.math.random(1,3)
        if mob.x < 4 then
          mob.direction = 3
        elseif mob.x > 26 then
          mob.direction = 1
        else
          mob.direction = direction
        end
        mob.directionTimer = 0
      end
    end
  end
end
function mobDirectionUpdate(allMob, deltaT, aggro)
  for _, mob in pairs(allMob) do
    mob.directionTimer = mob.directionTimer + deltaT * aggro
  end
end
function drawMob(allMob)
  for _, mob in pairs(allMob) do
      love.graphics.draw(ship.img,ship.quad[mob.frameActive],(mob.x-10*mob.scale),(mob.y-10*mob.scale),0,mob.scale,mob.scale)
  end
end

function mobFrameScale(allMob)
  for _, mob in pairs(allMob) do
    if mob.distance < 2 then
      if mob.direction == 1 then
        mob.frameActive = 1
      elseif mob.direction == 2 then
        mob.frameActive = 2
      elseif mob.direction == 3 then
        mob.frameActive = 3
      end
    elseif mob.distance > 2 and mob.distance < 3 then
      if mob.direction == 1 then
        mob.frameActive = 4
      elseif mob.direction == 2 then
        mob.frameActive = 5
      elseif mob.direction == 3 then
        mob.frameActive = 6
      end
    elseif mob.distance > 3 and mob.distance <5 then
      if mob.direction == 1 then
        mob.frameActive = 7
      elseif mob.direction == 2 then
        mob.frameActive = 8
      elseif mob.direction == 3 then
        mob.frameActive = 9
      end
    elseif mob.distance > 5 then
      if mob.direction == 1 then
        mob.frameActive = 10
      elseif mob.direction == 2 then
        mob.frameActive = 11
      elseif mob.direction == 3 then
        mob.frameActive = 12
      end
    end
  end
end
function mobScale(allMob)
  for _, mob in pairs(allMob) do
    if mob.scale < 1 then
      mob.scale = math.max(mob.distance/6,0.1)
    elseif mob.distance > 6 then
      mob.scale = 1
    end
  end
end
function mobLife(allMob)
  for _, mob in pairs(allMob) do
    if mob.hit == true then
      table.insert(allHit,Hit:new({x=mob.x,y=mob.y,scale=mob.scale,frameActive =1, hitTimer = 0}))
      mob.life = mob.life - 1
      mob.hit = false
    end
  end
end
function drawHit(allHit)
  if #allHit > 0 then
    for _, hit in pairs(allHit) do
      love.graphics.draw(hitBurn.img,hitBurn.quad[hit.frameActive],x,y,0,scale)
    end
  end
end
function hitBurning(allHit, deltaT)
  if #allHit > 0 then
    for _, hit in pairs(allHit) do
      hit.hitTimer = hit.hitTimer + deltaT * 20
      hit.frameActive = math.floor(hit.hitTimer)+1
      if hit.hitTimer > 3 then
        table.remove(allHit,_)
      end
    end
  end
end
function drawExplosion(allExplosion)
  if #allExplosion > 0 then
    for _, explosion in pairs(allExplosion) do
      love.graphics.draw(explode.img,explode.quad[explosion.frameActive],x,y,0,scale)
    end
  end
end
function explosionBurning(allExplosion, deltaT)
  if #allExplosion > 0 then
    for _, explosion in pairs(allExplosion) do
      explosion.explosionTimer = explosion.explosionTimer + deltaT * 20
      explosion.frameActive = math.floor(explosion.explosionTimer)+1
      if explosion.explosionTimer > 8 then
        table.remove(allExplosion,_)
      end
    end
  end
end


function drawPosition(allObject)
  for _, object in pairs(allObject) do
    love.graphics.print('x'..math.floor(object.x),object.x+2,object.y,0,0.1,0.1)
    love.graphics.print('y'..math.floor(object.y),object.x-2,object.y,0,0.1,0.1)
  end
end
function drawMobPosition(allMob)
  for _, mob in pairs(allMob) do
    love.graphics.print('x'..math.floor(mob.x),mob.x+2,mob.y,0,0.1,0.1)
    love.graphics.print('y'..math.floor(mob.y),mob.x-2,mob.y,0,0.1,0.1)
    love.graphics.print('f'..math.floor(mob.frameActive),mob.x-4,mob.y,0,0.1,0.1)    
    if hitbox == true then
    love.graphics.setColor(1,0,0,0.5)
      if mob.frameActive == 1 or mob.frameActive == 2 or mob.frameActive == 3 then
        love.graphics.rectangle("fill",mob.x-10*mob.scale,mob.y-10*mob.scale,10,10)
      elseif mob.frameActive == 4 or mob.frameActive == 5 or mob.frameActive == 6 then
        love.graphics.rectangle("fill",mob.x-10*mob.scale,mob.y-10*mob.scale,20,20)
      elseif mob.frameActive == 7 or mob.frameActive == 8 or mob.frameActive == 9 then
        love.graphics.rectangle("fill",mob.x-10*mob.scale,mob.y-10*mob.scale,30,30)
      elseif mob.frameActive == 10 or mob.frameActive == 11 or mob.frameActive == 12 then
        love.graphics.rectangle("fill",mob.x-10*mob.scale,mob.y-10*mob.scale,40,40)
      end
    love.graphics.setColor(1,1,1)
    end
  end
end

