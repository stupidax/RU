io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")

love.window.setMode(300,200)
love.window.setTitle("Proceptycide")

function love.load(arg)
if arg[#arg] == "-debug" then require("mobdebug").start() end

--require
Star = require("Star")
Shot = require("Shot")
Mob = require("Mob")
Hit = require("Hit")
Explosion = require("Explosion")
menu = require("menu")
require("intro")

-- RNG
rng = love.math.newRandomGenerator()

--font for game
  font = love.graphics.newImageFont("images/font.png",
    " abcdefghijklmnopqrstuvwxyz"..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ"..
    "0123456789"..
    ".\'?!,@")
  love.graphics.setFont(font)


--init var
allStar = {}
allLeftTopShot = {}
allCenterTopShot = {}
allRightTopShot = {}
allLeftMidShot = {}
allCenterMidShot = {}
allRightMidShot = {}
allLeftBotShot = {}
allCenterBotShot = {}
allRightBotShot = {}
allSet = {}
allMob = {}
allHit = {}
allExplosion = {}
speed = 1
life = 1
lifeMax = 1
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
reload = 1
mobCreationTimer = 0
menace = 1
menaceUp = 0
aggro = 2
randMobDirection = 2
randMobTimer = 1
mobDirectionTimer = 5
mobCreation = false
mobDirectionChange = false
score = 0
randMob1 = 0
randMob2 = 0
randMobPower = 0
aimTimer = 0
rtext = 0
redUp = false
alert = false
lightUp = false
ltext = 0
text = false
timerText = 0
level = 0
fade = 0.3
engine = false
gameState = "intro"
setUp = false
cursorTimer = 0
menuOn = false

set1 = {}
  set1.x = 0
  set1.y = -20
  set1.move1 = false
  set1.move2 = true
  set1.yGo1 = 0
  set1.yGo2 = -20
  set1.dir = "down"

set2 = {}
  set2.x = 0
  set2.y = 20
  set2.move1 = false
  set2.move2 = true
  set2.yGo1 = 0
  set2.yGo2 = 20
  set2.dir = "up"


set3 = {}
  set3.x = 0
  set3.y = -20
  set3.move1 = false
  set3.move2 = true
  set3.yGo1 = 0
  set3.yGo2 = -20
  set3.dir = "down"

allSet = {}
  table.insert(allSet,set1)
  table.insert(allSet,set2)
  table.insert(allSet,set3)

cursor = {}
  cursor.x = {7,10,14,18,24}
  cursor.y = {6,12,12,12,7}
  cursor.text = {"Ship Shield","Ship Speed","Missile","Shot Power","Ship Resistance"}

--init graph
bg = {}
  bg[11] = love.graphics.newImage("images/level/bgA1.png")
  bg[12] = love.graphics.newImage("images/level/bgA2.png")
  bg[21] = love.graphics.newImage("images/level/bgB1.png")
  bg[22] = love.graphics.newImage("images/level/bgB2.png")
  bg[1] = love.graphics.newImage("images/level/bgC1.png")
  bg[2] = love.graphics.newImage("images/level/bgC2.png")
  bg[3] = love.graphics.newImage("images/level/bgC3.png")
  bg[31] = love.graphics.newImage("images/level/bgD1.png")
  bg[32] = love.graphics.newImage("images/level/bgD2.png")
  bg[41] = love.graphics.newImage("images/level/bgE1.png")
  bg[42] = love.graphics.newImage("images/level/bgE2.png")

  set1.img = love.graphics.newImage("images/set/set1.png")
  set2.img = love.graphics.newImage("images/set/set2.png")
  set3.img = love.graphics.newImage("images/set/set3.png")
  
obj1 = {}
  obj1[1] = love.graphics.newImage("images/level/bgB3.png")
  obj1[2] = love.graphics.newImage("images/level/bgB4.png")
  obj1.x = 15
  obj1.y = 5
  obj1[3] = 15
  obj1[4] = 5
  obj1.scale = 0.1
  
board = {}
  board[1] = love.graphics.newImage("images/board/board.png")
  board[2] = love.graphics.newImage("images/board/boardLeft.png")
  board[3] = love.graphics.newImage("images/board/boardRight.png")
  board[4] = love.graphics.newImage("images/board/boardCenter.png")

shield = {}
  shield.img = love.graphics.newImage("images/afix/shield.png")
  shield.quad = quadCreation(shield.img)

ship = {}
  ship.img0 = love.graphics.newImage("images/mob/Mob0.png")
  ship.quad0 = quadCreation(ship.img0,20,20)
  ship.img1 = love.graphics.newImage("images/mob/Mob1.png")
  ship.quad1 = quadCreation(ship.img1,20,20)
  ship.img2 = love.graphics.newImage("images/mob/Mob2.png")
  ship.quad2 = quadCreation(ship.img2,20,20)

explode = {}
  explode.img = love.graphics.newImage("images/afix/explode.png")
  explode.quad = quadCreation(explode.img,20,20)
  
hitBurn = {}
  hitBurn.img = love.graphics.newImage("images/afix/hit.png")
  hitBurn.quad = quadCreation(hitBurn.img,20,20)

aim = {}
  aim.img = love.graphics.newImage("images/afix/aim.png")
  aim.quad = quadCreation(aim.img,5,5)
  aim.frameActive = 1
  
lifeMaxImg = {}
  lifeMaxImg.img = love.graphics.newImage("images/board/lifeMax.png")
  lifeMaxImg.quad = quadCreation(lifeMaxImg.img)
  lifeMaxImg.frameActive = lifeMax

setShield = {}
  setShield.img = love.graphics.newImage("images/set/shield.png")
  setShield.quad = quadCreation(setShield.img)
  setShield.frameActive = 1

setShot = {}
  setShot.img = love.graphics.newImage("images/set/shot.png")
  setShot.quad = quadCreation(setShot.img)
  setShot.frameActive = 1

setSpeed = {}
  setSpeed.img = love.graphics.newImage("images/set/speed.png")
  setSpeed.quad = quadCreation(setSpeed.img)
  setSpeed.frameActive = 1

setMissile = {}
  setMissile.img = love.graphics.newImage("images/set/missile.png")
  setMissile.quad = quadCreation(setMissile.img)
  setMissile.frameActive = 1

setLifeMax = {}
  setLifeMax.img = love.graphics.newImage("images/set/lifeMax.png")
  setLifeMax.quad = quadCreation(setLifeMax.img)
  setLifeMax.frameActive = 1

setCursor = {}
  setCursor.img = love.graphics.newImage("images/afix/cursor.png")
  setCursor.quad = quadCreation(setCursor.img,5,5)
  setCursor.frameActive = 1
  setCursor.pos = 1

--provisoire
hitbox = false

end

function love.draw()
  --scaling on screen
  love.graphics.scale(10,10)
if gameState == "intro" then
  drawIntro()
end
  
  
if gameState == "game" then
  --bg
  love.graphics.setColor(fade,fade,fade,1)
  if speed < 40 then
    love.graphics.draw(bg[1])
  else
    love.graphics.draw(bg[2])
  end
  love.graphics.setColor(1,1,1,1)

  --bg object
  if level == 2 then
  drawObj(obj1)
  end
  
  --star
  if level ~= 0 then
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

end
  --board
  love.graphics.setColor(fade,fade,fade,1)
  love.graphics.draw(board[1])
  love.graphics.draw(lifeMaxImg.img,lifeMaxImg.quad[lifeMax])
  love.graphics.setColor(1,1,1,1)
  
if level ~= 0 then
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
  drawShot(allLeftTopShot)
  drawShot(allCenterTopShot)
  drawShot(allRightTopShot)
  drawShot(allLeftMidShot)
  drawShot(allCenterMidShot)
  drawShot(allRightMidShot)
  drawShot(allLeftBotShot)
  drawShot(allCenterBotShot)
  drawShot(allRightBotShot)
  end

if engine == true then
  --reserve
  drawReserve(leftReserve,"left")
  drawReserve(rightReserve,"right")

  --draw Speed
  drawSpeed()

  --draw life
  drawLife()
end
  --draw Hit
  drawHit(allHit)
  
  --draw Explosion
  drawExplosion(allExplosion)
  
  if level ~= 0 then
  --draw Aim
  drawAim()
  end
  
  --drawSet
  drawSet(set1)
  drawSet(set2)
  drawSetStat(set1)
  
  drawSetCursor()
  
  --draw Alert
  if alert == true then
  drawAlert("ALERT")
  end
  --score
  
  --drawSetText
  drawSetText()
  end
  
  
  --hitbox
  if hitbox == true then
  drawHitBox(allMob)
  end
  
--[[
  --test 
  drawPosition(allLeftShot)
  drawPosition(allCenterShot)
  drawPosition(allRightShot)
  drawMobPosition(allMob)
  
  love.graphics.print("push space to activate/desactivate mob hitbox",0,0,0,0.1,0.1)
  
  ]]--
end

function love.update(dt)

if gameState == "intro" then
  playIntro(dt)
end

if gameState == "game" then
  --set
  moveSet(set1)
  moveSet(set2)

  --setCursor
  if setUp == true then
  cursorTimer = cursorTimer + dt * 5
  if cursorTimer > 1 then
    cursorTimer = cursorTimer - 1
    setCursor.frameActive = 1
  end
  setCursor.frameActive = animator(setCursor.frameActive, 2, 1, cursorTimer)
  end

if level ~= 0 then
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
  if #allLeftTopShot > 0 then
  moveShot(allLeftTopShot, dt)
  shotDestruction(allLeftTopShot)
  end
  if #allCenterTopShot > 0 then
  moveShot(allCenterTopShot, dt)
  shotDestruction(allCenterTopShot)
  end
  if #allRightTopShot > 0 then
  moveShot(allRightTopShot, dt)
  shotDestruction(allRightTopShot)
  end
  if #allLeftMidShot > 0 then
  moveShot(allLeftMidShot, dt)
  shotDestruction(allLeftMidShot)
  end
  if #allCenterMidShot > 0 then
  moveShot(allCenterMidShot, dt)
  shotDestruction(allCenterMidShot)
  end
  if #allRightMidShot > 0 then
  moveShot(allRightMidShot, dt)
  shotDestruction(allRightMidShot)
  end
  if #allLeftBotShot > 0 then
  moveShot(allLeftBotShot, dt)
  shotDestruction(allLeftBotShot)
  end
  if #allCenterBotShot > 0 then
  moveShot(allCenterBotShot, dt)
  shotDestruction(allCenterBotShot)
  end
  if #allRightBotShot > 0 then
  moveShot(allRightBotShot, dt)
  shotDestruction(allRightBotShot)
  end

  --shield
  if speed > 20 then
    shieldActive = true
    shieldTimer = shieldTimer + dt
    if shieldTimer > 0.2 then
      shieldTimer = shieldTimer - 0.2
    end
    shieldFrame = animator(shieldFrame,5,0.2,shieldTimer)
  else
    shieldActive = false
  end
end
  --txt alert warning
  if alert == true then
    if redUp == true then
    rtext = rtext + 0.02
    else
    rtext = rtext - 0.02
    end
    if rtext >= 0.8 then
    redUp = false
    elseif rtext <= 0.1 then
    redUp = true
    end
  end

  --txt
  if text == true then
    if lightUp == true then
    ltext = ltext + 0.02
    else
    ltext = ltext - 0.02
    end
    if ltext >= 0.8 then
    lightUp = false
    elseif ltext <= 0.1 then
    lightUp = true
    end
  end

if level ~= 0 then

  --moving bg object
    moveObj(obj1,dt)

  --timer for reserve
  if leftReserve < 5 then
    leftReserveTimer = leftReserveTimer + dt *0.5* reload
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

  --reload
  if speed > 10 then
    reload = 4
  elseif speed > 20 then
    reload = 7
  elseif speed > 40 then
    reload = 10
  else
    reload = 2
  end
  
  --menace
  if menaceUp > 5 then
    menace = menace + 1
    menaceUp = 0
  end
  
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
  if mobCreationTimer > 5 and mobCreation == false then
    mobCreationTimer = mobCreationTimer - 10
    randMob1 = math.random(5,25)
    randMob2 = math.random(2,13)
    randMobTimerDirection = math.random(1,5)
    randMobPower = math.random(1,10)
    if randMobPower < 4 then
      if randMob1 < 13 then
        asteroid = 3
      elseif randMob1 > 17 then
        asteroid = 1
      elseif randMob1 > 13 and randMob1 < 17 then
        asteroid = 3
      end
      mobCreation = true
      table.insert(allMob, Mob:new({x=randMob1,y=randMob2,speed=3,life=1,direction=asteroid,frameActive=asteroid,scale=0.1,directionTimer=0,distance=0,directionChange=false,hit=false,xHitBox={1,1,2,3}, yHitBox={1,1,2,3},power=0}))
      mobCreation = false
    elseif randMobPower > 4 and randMobPower < 8 then
      table.insert(allMob, Mob:new({x=randMob1,y=randMob2,speed=2,life=2,direction=randMobDirection,frameActive=randMobDirection,scale=0.1,directionTimer=0,distance=0,directionChange=true,hit=false,xHitBox={1,1,2,3}, yHitBox={1,1,2,3},power=1}))
      mobCreation = false
    elseif randMobPower > 8 then
      table.insert(allMob, Mob:new({x=randMob1,y=randMob2,speed=1,life=3,direction=randMobDirection,frameActive=randMobDirection,scale=0.1,directionTimer=0,distance=0,directionChange=true,hit=false,xHitBox={1,2,5,8},yHitBox={1,2,5,5},power=2}))
      mobCreation = false
    end
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
  shotHit(allLeftTopShot, allMob)
  shotHit(allCenterTopShot, allMob)
  shotHit(allRightTopShot, allMob)
  shotHit(allLeftMidShot, allMob)
  shotHit(allCenterMidShot, allMob)
  shotHit(allRightMidShot, allMob)
  shotHit(allLeftBotShot, allMob)
  shotHit(allCenterBotShot, allMob)
  shotHit(allRightBotShot, allMob)

  --hit animation
  hitBurning(allHit, dt)
  explosionBurning(allExplosion, dt)
  
  --aim position
  if love.keyboard.isDown("up") then
    aimUp = -5
    aimPosUp = 10
  else
    aimUp = 0
    aimPosUp = 20
  end
  if love.keyboard.isDown("down") then
    aimDown = 5
    aimPosDown = 10
  else
    aimDown = 0
    aimPosDown = 0
  end
  if love.keyboard.isDown("left") then
    aimLeft = -11
    aimPosLeft = 1
  else
    aimLeft = 0
    aimPosLeft = 2
  end
  if love.keyboard.isDown("right") then
    aimRight = 10
    aimPosRight = 1
  else
    aimRight = 0
    aimPosRight = 0
  end
  
  aimX = 15 + aimRight + aimLeft
  aimY = 8 + aimUp + aimDown
  aimPosY = aimPosUp + aimPosDown
  aimPosX = aimPosRight + aimPosLeft
  aimPos = aimPosX + aimPosY

  --aim animation
  aimTimer = aimTimer + dt * 5
  if aimTimer > 1 then
    aimTimer = aimTimer - 1
    aim.frameActive = 1
  end
  aim.frameActive = animator(aim.frameActive, 2, 1, aimTimer)
end
end
end
function love.keypressed(key)
  --quit
  if key == "escape" then
    love.event.push("quit")
  end
  
  if gameState == "game" then
  --set use
  if key == "a" then
    for _, set in pairs(allSet) do
      if set.move1 == false then
        set.move1 = true
      else
        set.move1 = false
      end
    end
  end
  
  --speed up (temp)
  if key == "kp+" then
    for _, star in pairs(allStar) do
      star.speed = star.speed + 1
    end
    speed = speed + 1
    lifeMax = lifeMax + 1
  end
  
  --speed down (temp)
  if key == "kp-" then
    for _, star in pairs(allStar) do
      star.speed = star.speed - 1
    end    
    speed = speed - 1
    lifeMax = lifeMax - 1
  end
  
  if level ~= 0 then
  --primary shot pos 1 left
  if key == "t" then
    if aimPos == 11 then
      if leftReserve > 0 then
        leftReserve = leftReserve - 1
        leftShotTimer = 0
        leftShot = true
        table.insert(allLeftTopShot,Shot:new({x=2,y=15,speed=1,scale=1,hit=false,pos=aimPos}))
      end
    end
    if aimPos == 21 then
      if leftReserve > 0 then
        leftReserve = leftReserve - 1
        leftShotTimer = 0
        leftShot = true
        table.insert(allLeftMidShot,Shot:new({x=2,y=15,speed=1,scale=1,hit=false,pos=aimPos}))
      end
    end
    if aimPos == 31 then
      if leftReserve > 0 then
        leftReserve = leftReserve - 1
        leftShotTimer = 0
        leftShot = true
        table.insert(allLeftBotShot,Shot:new({x=2,y=15,speed=1,scale=1,hit=false,pos=aimPos}))
      end
    end
    if aimPos == 12 then
      if leftReserve > 0 or rightReserve > 0 then
        centerShotTimer = 0
        centerShot = true
          if leftReserve > 0 then
          leftReserve = leftReserve - 1
          table.insert(allCenterTopShot,Shot:new({x=4,y=15,speed=1,scale=1,hit=false,pos=aimPos}))
          end
          if rightReserve > 0 then
          rightReserve = rightReserve - 1
          table.insert(allCenterTopShot,Shot:new({x=25,y=15,speed=1,scale=1,hit=false,pos=aimPos}))
          end
      end
    end
    if aimPos == 22 then
      if leftReserve > 0 or rightReserve > 0 then
        centerShotTimer = 0
        centerShot = true
          if leftReserve > 0 then
          leftReserve = leftReserve - 1
          table.insert(allCenterMidShot,Shot:new({x=4,y=15,speed=1,scale=1,hit=false,pos=aimPos}))
          end
          if rightReserve > 0 then
          rightReserve = rightReserve - 1
          table.insert(allCenterMidShot,Shot:new({x=25,y=15,speed=1,scale=1,hit=false,pos=aimPos}))
          end
      end
    end
    if aimPos == 32 then
      if leftReserve > 0 or rightReserve > 0 then
        centerShotTimer = 0
        centerShot = true
          if leftReserve > 0 then
          leftReserve = leftReserve - 1
          table.insert(allCenterBotShot,Shot:new({x=4,y=15,speed=1,scale=1,hit=false,pos=aimPos}))
          end
          if rightReserve > 0 then
          rightReserve = rightReserve - 1
          table.insert(allCenterBotShot,Shot:new({x=25,y=15,speed=1,scale=1,hit=false,pos=aimPos}))
          end
      end
    end
    if aimPos == 13 then
      if rightReserve > 0 then
        rightReserve = rightReserve - 1
        rightShotTimer = 0
        rightShot = true
        table.insert(allRightTopShot,Shot:new({x=27,y=15,speed=1,scale=1,hit=false,pos=aimPos}))
      end
    end
    if aimPos == 23 then
      if rightReserve > 0 then
        rightReserve = rightReserve - 1
        rightShotTimer = 0
        rightShot = true
        table.insert(allRightMidShot,Shot:new({x=27,y=15,speed=1,scale=1,hit=false,pos=aimPos}))
      end
    end
    if aimPos == 33 then
      if rightReserve > 0 then
        rightReserve = rightReserve - 1
        rightShotTimer = 0
        rightShot = true
        table.insert(allRightBotShot,Shot:new({x=27,y=15,speed=1,scale=1,hit=false,pos=aimPos}))
      end
    end
  end
  end
  
  --hitbox debugmode
  if key == "space" then
    if hitbox == false then
      hitbox = true
    else
      hitbox = false
    end
  end

  --setCursor
  if setUp == true then
    if key == "left" then
      if setCursor.pos > 1 then
      setCursor.pos = setCursor.pos - 1
      elseif setCursor.pos == 1 then
      setCursor.pos = 5
      end
    end
    if key == "right" then
      if setCursor.pos == 5 then
      setCursor.pos = 1
      elseif setCursor.pos < 5 then
      setCursor.pos = setCursor.pos + 1
      end
    end
  end
  
  --start engine
  if key == "return" then
    if engine == false then
      engine = true
    else
      engine = false
    end
  end
end
end

function drawStar()
  for _, star in pairs(allStar) do
    love.graphics.circle("fill",star.x,star.y,star.scale/2)
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
      if shot.pos == 11 then
        shot.x = shot.x + 2 * deltaT
        shot.y = shot.y - 20 * deltaT
        shot.scale = math.max((shot.y-2)/13,.1)
      end
      if shot.pos == 21 then
        shot.x = shot.x + 3 * deltaT
        shot.y = shot.y - 10 * deltaT
        shot.scale = math.max((shot.y-6)/9,.1)
      end
      if shot.pos == 31 then
        shot.x = shot.x + 4 * deltaT
        shot.y = shot.y - 5 * deltaT
        shot.scale = math.max((shot.y-11)/4,.1)
      end
      if shot.pos == 12 then
        if shot.x > 15 then
          shot.x = shot.x - 16 * deltaT
        else
          shot.x = shot.x + 16 * deltaT
        end
        shot.y = shot.y - 20 * deltaT
        shot.scale = math.max((shot.y-2)/13,.1)
      end
      if shot.pos == 22 then
        if shot.x > 15 then
          shot.x = shot.x - 13 * deltaT
        else
          shot.x = shot.x + 13 * deltaT
        end
        shot.y = shot.y - 10 * deltaT
        shot.scale = math.max((shot.y-6)/9,.1)
      end
      if shot.pos == 32 then
        if shot.x > 15 then
          shot.x = shot.x - 15 * deltaT
        else
          shot.x = shot.x + 15 * deltaT
        end
        shot.y = shot.y - 5 * deltaT
        shot.scale = math.max((shot.y-11)/4,.1)
      end
      if shot.pos == 13 then
        shot.x = shot.x - 2 * deltaT
        shot.y = shot.y - 20 * deltaT
        shot.scale = math.max((shot.y-2)/13,.1)
      end
      if shot.pos == 23 then
        shot.x = shot.x - 3 * deltaT
        shot.y = shot.y - 10 * deltaT
        shot.scale = math.max((shot.y-6)/9,.1)
      end
      if shot.pos == 33 then
        shot.x = shot.x - 4 * deltaT
        shot.y = shot.y - 5 * deltaT
        shot.scale = math.max((shot.y-11)/4,.1)
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
  if #allShot > 0 then
    if #allMob > 0 then
      for _, shot in pairs(allShot) do
        for _, mob in pairs(allMob) do
          if mob.frameActive == 1 or mob.frameActive == 2 or mob.frameActive == 3 then
            if (shot.x > mob.x-mob.xHitBox[1]*mob.scale and shot.x < mob.x+mob.xHitBox[1]*mob.scale) and (shot.y > mob.y-mob.yHitBox[1]*mob.scale and shot.y < mob.y+mob.yHitBox[1]*mob.scale) then
              shot.hit = true
              mob.hit = true
            end
          elseif mob.frameActive == 4 or mob.frameActive == 5 or mob.frameActive == 6 then
            if (shot.x > mob.x-mob.xHitBox[2]*mob.scale and shot.x < mob.x+mob.xHitBox[2]*mob.scale) and (shot.y > mob.y-mob.yHitBox[1]*mob.scale and shot.y < mob.y+mob.yHitBox[2]*mob.scale) then
              shot.hit = true
              mob.hit = true
            end
          elseif mob.frameActive == 7 or mob.frameActive == 8 or mob.frameActive == 9 then
            if (shot.x > mob.x-mob.xHitBox[3]*mob.scale and shot.x < mob.x+mob.xHitBox[3]*mob.scale) and (shot.y > mob.y-mob.yHitBox[1]*mob.scale and shot.y < mob.y+mob.yHitBox[3]*mob.scale) then
              shot.hit = true
              mob.hit = true
            end
          elseif mob.frameActive == 10 or mob.frameActive == 11 or mob.frameActive == 12 then
            if (shot.x > mob.x-mob.xHitBox[4]*mob.scale and shot.x < mob.x+mob.xHitBox[4]*mob.scale) and (shot.y > mob.y-mob.yHitBox[1]*mob.scale and shot.y < mob.y+mob.yHitBox[4]*mob.scale) then
              shot.hit = true
              mob.hit = true
            end
          end
        end
      end
    end
  end
end

function shotDestruction(allShot)
    for _, shot in pairs(allShot) do
      if shot.hit == true then
        table.insert(allHit,Hit:new({x=shot.x,y=shot.y,scale=shot.scale,frameActive =1, hitTimer = 0}))
        table.remove(allShot, _)
      else
        if shot.pos == 11 then
          if math.floor(shot.y) == 2 then
            table.remove(allShot, _)
          end
        end
        if shot.pos == 21 then
          if math.floor(shot.y) == 6 then
            table.remove(allShot, _)
          end
        end
        if shot.pos == 31 then
          if math.floor(shot.y) == 11 then
            table.remove(allShot, _)
          end
        end
        if shot.pos == 12 then
          if math.floor(shot.y) == 2 then
            table.remove(allShot, _)
          end
        end
        if shot.pos == 22 then
          if math.floor(shot.y) == 6 then
            table.remove(allShot, _)
          end
        end
        if shot.pos == 32 then
          if math.floor(shot.y) == 11 then
            table.remove(allShot, _)
          end
        end
      end
        if shot.pos == 13 then
          if math.floor(shot.y) == 2 then
            table.remove(allShot, _)
          end
        end
        if shot.pos == 23 then
          if math.floor(shot.y) == 6 then
            table.remove(allShot, _)
          end
        end
        if shot.pos == 33 then
          if math.floor(shot.y) == 11 then
            table.remove(allShot, _)
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

function animator(frameQuad, frameNumber, animationDuration, animTimer)
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
        if mob.y > 13 then
          mob.y = mob.y - deltaT * mob.speed
        else
          mob.y = mob.y + deltaT * mob.speed
        end
        mob.x = mob.x - deltaT * mob.speed
      elseif mob.direction == 2 then
        if mob.y > 13 then
          mob.y = mob.y - deltaT * mob.speed
        else
          mob.y = mob.y + deltaT * mob.speed
        end
      elseif mob.direction == 3 then
        if mob.y > 13 then
          mob.y = mob.y - deltaT * mob.speed
        else
          mob.y = mob.y + deltaT * mob.speed
        end
        mob.x = mob.x + deltaT * mob.speed
      end
    elseif mob.distance > 3 and mob.distance < 4 then
      if mob.direction == 1 then
        if mob.y > 13 then
          mob.y = mob.y - deltaT * (1+mob.speed)
        else
          mob.y = mob.y + deltaT * (1+mob.speed)
        end
        mob.x = mob.x - deltaT * (1+mob.speed)
      elseif mob.direction == 2 then
        if mob.y > 13 then
          mob.y = mob.y - deltaT * (1+mob.speed)
        else
          mob.y = mob.y + deltaT * (1+mob.speed)
        end
      elseif mob.direction == 3 then
        if mob.y > 13 then
          mob.y = mob.y - deltaT * (1+mob.speed)
        else
          mob.y = mob.y + deltaT * (1+mob.speed)
        end
        mob.x = mob.x + deltaT * (1+mob.speed)
      end
    elseif mob.distance > 4 and mob.distance < 6 then
      if mob.direction == 1 then
        if mob.y > 13 then
          mob.y = mob.y + deltaT * (2+mob.speed)
        else
          mob.y = mob.y + deltaT * (2+mob.speed)
        end
        mob.x = mob.x - deltaT * (3+mob.speed)
      elseif mob.direction == 2 then
        if mob.y > 13 then
          mob.y = mob.y + deltaT * (2+mob.speed)
        else
          mob.y = mob.y + deltaT * (2+mob.speed)
        end
      elseif mob.direction == 3 then
        if mob.y > 13 then
          mob.y = mob.y + deltaT * (2+mob.speed)
        else
          mob.y = mob.y + deltaT * (2+mob.speed)
        end
        mob.x = mob.x + deltaT * (3+mob.speed)
      end
    elseif mob.distance > 6 then
      if mob.direction == 1 then
        mob.y = mob.y - deltaT * (5+mob.speed)
        mob.x = mob.x - deltaT * (5+mob.speed)
      elseif mob.direction == 2 then
        mob.y = mob.y - deltaT * (5+mob.speed)
      elseif mob.direction == 3 then
        mob.y = mob.y - deltaT * (5+mob.speed)
        mob.x = mob.x + deltaT * (5+mob.speed)
      end
    end
  end
end
function mobDistanceUpdate(allMob, deltaT)
    for _, mob in pairs(allMob) do
    mob.distance = mob.distance + math.min(deltaT * 2, 5)
  end
end
function mobDestruction(allMob)
    for _, mob in pairs(allMob) do
      if mob.life == 0 then
        table.insert(allExplosion,Explosion:new({x=mob.x,y=mob.y,scale=mob.scale,frameActive=1,explosionTimer=0}))
        table.remove(allMob, _)
        speed = speed + mob.power
        score = score + mob.power
        if menaceUp < 10 then
          menaceUp = menaceUp + 1
        end
      elseif mob.y > 40  or mob.x > 50 or mob.x < -20 or mob.y < -10 then
        table.remove(allMob, _)
        if speed > 1 then
          speed = speed /2
        end
        if reload > 1 then
          reload = reload - 1
        end
        life = life - 1
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
      love.graphics.draw(ship["img"..mob.power],ship["quad"..mob.power][mob.frameActive],(mob.x-10*mob.scale),(mob.y-10*mob.scale),0,mob.scale,mob.scale)
  end
end

function mobFrameScale(allMob)
  for _, mob in pairs(allMob) do
    if mob.distance < 1 then
      if mob.direction == 1 then
        mob.frameActive = 1
      elseif mob.direction == 2 then
        mob.frameActive = 2
      elseif mob.direction == 3 then
        mob.frameActive = 3
      end
    elseif mob.distance > 1 and mob.distance < 2 then
      if mob.direction == 1 then
        mob.frameActive = 4
      elseif mob.direction == 2 then
        mob.frameActive = 5
      elseif mob.direction == 3 then
        mob.frameActive = 6
      end
    elseif mob.distance > 2 and mob.distance <4 then
      if mob.direction == 1 then
        mob.frameActive = 7
      elseif mob.direction == 2 then
        mob.frameActive = 8
      elseif mob.direction == 3 then
        mob.frameActive = 9
      end
    elseif mob.distance > 4 then
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
      mob.life = mob.life - 1
      mob.hit = false
    end
  end
end
function drawHit(allHit)
  if #allHit > 0 then
    for _, hit in pairs(allHit) do
      love.graphics.draw(hitBurn.img,hitBurn.quad[hit.frameActive],hit.x-10*hit.scale,hit.y-10*hit.scale,0,hit.scale)
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
      love.graphics.draw(explode.img,explode.quad[explosion.frameActive],explosion.x-10*explosion.scale,explosion.y-10*explosion.scale,0,explosion.scale)
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
        love.graphics.rectangle("fill",mob.x-10*mob.scale,mob.y-10*mob.scale,10*mob.scale,10*mob.scale)
      elseif mob.frameActive == 4 or mob.frameActive == 5 or mob.frameActive == 6 then
        love.graphics.rectangle("fill",mob.x-10*mob.scale,mob.y-10*mob.scale,20*mob.scale,20*mob.scale)
      elseif mob.frameActive == 7 or mob.frameActive == 8 or mob.frameActive == 9 then
        love.graphics.rectangle("fill",mob.x-10*mob.scale,mob.y-10*mob.scale,30*mob.scale,30*mob.scale)
      elseif mob.frameActive == 10 or mob.frameActive == 11 or mob.frameActive == 12 then
        love.graphics.rectangle("fill",mob.x-10*mob.scale,mob.y-10*mob.scale,40*mob.scale,40*mob.scale)
      end
    love.graphics.setColor(1,1,1)
    end
  end
end
function drawAim()
  love.graphics.draw(aim.img,aim.quad[aim.frameActive],aimX-2.5,aimY-2.5)
end
function drawHitBox(allMob)
  for _, mob in pairs(allMob) do
  love.graphics.setColor(1,0,0,0.3)
    if mob.frameActive == 1 or mob.frameActive == 2 or mob.frameActive == 3 then
    love.graphics.rectangle("fill",mob.x-mob.xHitBox[1]*mob.scale,mob.y-mob.yHitBox[1]*mob.scale,2*mob.xHitBox[1]*mob.scale,2*mob.yHitBox[1]*mob.scale)
    elseif mob.frameActive == 4 or mob.frameActive == 5 or mob.frameActive == 6 then
    love.graphics.rectangle("fill",mob.x-mob.xHitBox[2]*mob.scale,mob.y-mob.yHitBox[2]*mob.scale,2*mob.xHitBox[2]*mob.scale,2*mob.yHitBox[2]*mob.scale)
    elseif mob.frameActive == 7 or mob.frameActive == 8 or mob.frameActive == 9 then
    love.graphics.rectangle("fill",mob.x-mob.xHitBox[3]*mob.scale,mob.y-mob.yHitBox[3]*mob.scale,2*mob.xHitBox[3]*mob.scale,2*mob.yHitBox[3]*mob.scale)
    elseif mob.frameActive == 10 or mob.frameActive == 11 or mob.frameActive == 12 then
    love.graphics.rectangle("fill",mob.x-mob.xHitBox[4]*mob.scale,mob.y-mob.yHitBox[4]*mob.scale,2*mob.xHitBox[4]*mob.scale,2*mob.yHitBox[4]*mob.scale)
    end
  love.graphics.setColor(1,1,1,1)
  end
end
function drawSpeed()
  if speed < 40 then
    for i=0,math.floor(speed/38*8),1 do
      love.graphics.setColor(0,0.9,0)
      love.graphics.rectangle("fill",10+i,17,1,1)
      love.graphics.setColor(1,1,1)
    end
  else 
    for i=0,8,1 do
      love.graphics.setColor(0,0.9,0)
      love.graphics.rectangle("fill",10+i,17,1,1)
    end
    love.graphics.rectangle("fill",18,16,1,1)
    love.graphics.setColor(1,1,1)
  end
end
function drawLife()
  for i=1,life,1 do
    love.graphics.setColor(0.8,0,0)
    love.graphics.rectangle("fill",12+i,19,1,1)
    love.graphics.setColor(1,1,1)
  end
end
function drawObj(obj)
  if speed < 40 then
    if obj.scale < 1 then
    love.graphics.draw(obj[1],obj.x-obj.x*obj.scale,obj.y-obj.y*obj.scale,0,obj.scale,obj.scale)
    else
    love.graphics.draw(obj[1],obj.x-obj[3],obj.y-obj[4],0,obj.scale,obj.scale)
    end
  else
    if obj.scale < 1 then
    love.graphics.draw(obj[2],obj.x-obj.x*obj.scale,obj.y-obj.y*obj.scale,0,obj.scale,obj.scale)
    else
    love.graphics.draw(obj[2],obj.x-obj[3],obj.y-obj[4],0,obj.scale,obj.scale)
    end
  end
end
function moveObj(obj,deltaT)
  if obj.scale < 1 then
  obj.scale = math.max(obj.scale + deltaT * speed/2000,0.1)
  end
end
function drawAlert(text)
  love.graphics.setColor(0.2+rtext,0,0)
  love.graphics.print(text,2,2,0,0.5,0.5)
  love.graphics.setColor(1,1,1)
end
function drawText(text)
  love.graphics.setColor(0+ltext,0+ltext,0+ltext)
  love.graphics.print(text,2,2,0,0.5,0.5)
  love.graphics.setColor(1,1,1)
end
function drawSet(set)
  love.graphics.draw(set.img,set.x,set.y)
end
function drawSetStat(set)
  love.graphics.draw(setLifeMax.img,setLifeMax.quad[setLifeMax.frameActive],set.x,set.y)
  love.graphics.draw(setShot.img,setShot.quad[setShot.frameActive],set.x,set.y)
  love.graphics.draw(setSpeed.img,setSpeed.quad[setSpeed.frameActive],set.x,set.y)
  love.graphics.draw(setMissile.img,setMissile.quad[setMissile.frameActive],set.x,set.y)
  love.graphics.draw(setShield.img,setShield.quad[setShield.frameActive],set.x,set.y)
end
function moveSet(set)
  if set.dir == "down" then
    if set.move1 == true and set.y < set.yGo1 then
      set.y = set.y + 1
      set.move2 = true
      setUp = true
    end
    if set.move2 == true and set.move1 == false and set.y > set.yGo2 then
      set.y = set.y - 1
    elseif set.y == set.yGo2 and set.move2 == true then
      set.move2 = false
      setUp = false
    end
  else
    if set.move1 == true and set.y > set.yGo1 then
      set.y = set.y - 1
      set.move2 = true
      setUp = true

    end
    if set.move2 == true and set.move1 == false and set.y < set.yGo2 then
      set.y = set.y + 1
    elseif set.y == set.yGo2 and set.move2 == true then
      set.move2 = false
      setUp = false
    end
  end
end
function drawSetCursor()
  love.graphics.draw(setCursor.img,setCursor.quad[setCursor.frameActive],cursor.x[setCursor.pos]-2+set1.x,cursor.y[setCursor.pos]-2+set1.y)
end
function drawSetText()
  love.graphics.print(cursor.text[setCursor.pos],3+set2.x,17+set2.y,0,0.3,0.3)
end