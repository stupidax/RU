--intro
require("main")

--init
intro = {}

intro.Timer = 0
intro.Timer0 = 0
intro.Timer1 = 0
intro.Timer2 = 0
intro.Timer3 = 0
intro.Timer4 = 0
intro.Timer5 = 0
intro.Timer6 = 0

intro.start = false
intro.sc0 = false
intro.sc1 = false
intro.sc2 = false
intro.sc3 = false
intro.sc4 = false
intro.sc5 = false
intro.sc6 = false

intro.startEnd = false
intro.sc0End = false
intro.sc1End = false
intro.sc2End = false
intro.sc3End = false
intro.sc4End = false
intro.sc5End = false
intro.sc6End = false


intro.planeteX1 = 0
intro.planeteX2 = 0
intro.planeteS1 = 0
intro.planeteS2 = 0
intro.cityY = 0
intro.ascY = 0
intro.ascDoorX = 0
intro.doorX = 0
intro.padY = 0
intro.padTextY = 0
intro.text = 1
intro.fade = 1
intro.textScale = 0.15

--init graph
  --scene
  sc0Bg = love.graphics.newImage("images/intro/intro0-0.png")
  sc0Obj1 = love.graphics.newImage("images/intro/intro0-1a.png")
  sc0Obj2 = love.graphics.newImage("images/intro/intro0-1b.png")
  sc0Obj3 = love.graphics.newImage("images/intro/intro0-1c.png")
  
  sc1Bg = {}
    sc1Bg.img = love.graphics.newImage("images/intro/intro1-city.png")
    sc1Bg.quad = quadCreation(sc1Bg.img)
    sc1Bg.frameActive = 1
    
  sc1City = love.graphics.newImage("images/intro/intro1-city2.png")
  
  sc1Ship = {}
    sc1Ship.img = love.graphics.newImage("images/intro/intro1-ship.png")
    sc1Ship.quad = quadCreation(sc1Ship.img)
    sc1Ship.frameActive = 1
  
  sc2Bg = love.graphics.newImage("images/intro/intro2-0.png")
  sc2Light = love.graphics.newImage("imageS/intro/intro2-1.png")
  sc2LeftDoor = love.graphics.newImage("imageS/intro/intro2-1a.png")
  sc2RightDoor = love.graphics.newImage("imageS/intro/intro2-1b.png")
  sc2Door = {}
    sc2Door.img = love.graphics.newImage("imageS/intro/intro2-door.png")
    sc2Door.quad = quadCreation(sc2Door.img)
    sc2Door.frameActive = 1
  
  sc3Bg = {}
    sc3Bg.img = love.graphics.newImage("images/intro/intro3-walk.png")
    sc3Bg.quad = quadCreation(sc3Bg.img)
    sc3Bg.frameActive = 1
  
  sc4Bg1 = love.graphics.newImage("images/intro/intro4-0.png")
  sc4Bg2 = love.graphics.newImage("images/intro/intro4-1.png")
  sc4Obj = love.graphics.newImage("images/intro/intro4-1a.png")
  sc4Bg3 = love.graphics.newImage("images/intro/intro4-2.png")

  sc5Obj1 = love.graphics.newImage("images/intro/intro5-0.png")
  sc5Obj2 = love.graphics.newImage("images/intro/intro5-1.png")
  sc5Obj3 = love.graphics.newImage("images/intro/intro5-1a.png")

  sc6Bg0 = love.graphics.newImage("images/intro/intro6-0.png")
  sc6Bg1 = love.graphics.newImage("images/intro/intro6-1.png")

function playIntro(dt)
-- déroulement
intro.Timer = intro.Timer + dt

--Déroulement : start
  if intro.Timer > 1 and intro.start == false then
    intro.start = true
  end
  
--Déroulement : sc0
  if intro.Timer > 8 and intro.sc1 == false then
    intro.startEnd = true
    intro.sc0End = true
    intro.sc1 = true
    intro.Timer0 = 0
  end
  
--Déroulement : sc1
  if intro.Timer > 19 and intro.sc2 == false then
    intro.sc1End = true
    intro.sc2 = true
    intro.Timer0 = 0
    intro.Timer1 = 0
  end
  
--Déroulement : sc2
  if intro.Timer > 29 and intro.sc3 == false then
    intro.sc2End = true
    intro.sc3 = true
    intro.Timer0 = 0
    intro.Timer1 = 0
  end
  
  --Déroulement : sc3
  if intro.Timer > 32 and intro.sc4 == false then
    intro.sc3End = true
    intro.sc4 = true
    intro.Timer0 = 0
    intro.Timer1 = 0
  end
  
  --Déroulement : sc4 spécial
  if intro.Timer > 46 and intro.sc5 == false then
    intro.sc5 = true
  end
  
  --Déroulement : sc5
  if intro.Timer > 65 and intro.sc5 == true then
    intro.sc4End = true
    intro.sc5End = true
    intro.sc6 = true
  end
  
  --Déroulement : sc6 + End intro
  if intro.Timer > 75 and intro.sc6 == true then
    intro.sc6End = true
    gameState = "game"
    love.graphics.setColor(1,1,1,1)
  end

  

  
--sc0
  if intro.Timer0 > 1 and intro.sc0 == false then
    intro.sc0 = true
  end
  if intro.start == true and intro.startEnd == false then
    intro.Timer0 = intro.Timer0 + dt*.5
    intro.planeteX1 = intro.planeteX1 - 0.005
    if intro.sc0 == true and intro.sc0End == false then
      intro.planeteX2 = intro.planeteX2 - 0.005
      intro.planeteS1 = intro.planeteS1 + 0.001
      intro.planeteS2 = intro.planeteS2 - 0.02
    end
  end

--sc1
  if intro.Timer > 9 and intro.sc1 == true and intro.sc1End == false then
    if intro.Timer1 < 6 then
      intro.Timer1 = intro.Timer1 + dt *20
    end
    sc1Ship.frameActive = math.floor(intro.Timer1)+1
  end
  if intro.Timer > 9 and intro.sc1 == true then
    if intro.Timer0 < 4 then
      intro.Timer0 = intro.Timer0 + dt
    elseif intro.Timer0 >= 4 and intro.Timer0 < 10 then
      intro.Timer0 = intro.Timer0 + dt*3
    end
    sc1Bg.frameActive = math.floor(intro.Timer0)+1
  end
  if intro.Timer > 15 then
    intro.cityY = intro.cityY + 0.01
  end
  
  --sc2
  if intro.Timer > 19 and intro.sc2 == true then
    if intro.ascY < 80 then
      intro.Timer1 = intro.Timer1 + dt
      if intro.Timer1 > 1 then
        intro.Timer1 = intro.Timer1 - 1
        sc2Door.frameActive = 1
      end
      sc2Door.frameActive = animator(sc2Door.frameActive, 4, 1, intro.Timer1)
      intro.ascY = intro.ascY + 0.2
    else
      if intro.ascDoorX < 13 then
        intro.ascDoorX = intro.ascDoorX + 0.1
      end
    end
  end
  
  --sc3
  if intro.sc3 == true and intro.sc3End == false then
    if intro.Timer1 < 1.5 then
    intro.Timer1 = intro.Timer1 + dt
    end
    sc3Bg.frameActive = animator(sc3Bg.frameActive, 6, 1.5, intro.Timer1)
  end

  --sc4
  if intro.sc4 == true and intro.sc4End == false then
    if intro.Timer > 34 and intro.doorX < 26 then
      intro.doorX = intro.doorX + 1
    end
    if intro.Timer > 41 then
      if intro.padY > -20 then
        intro.padY = intro.padY - 0.5
      end
    end
  end
  
  --sc5
  if intro.sc5 == true and intro.sc5End == false then
    if intro.Timer < 50 then
      intro.Timer4 = intro.Timer4 + dt
      if intro.Timer4 > 2 then
        intro.Timer4 = intro.Timer4 - 2
      end
    elseif intro.text == 1 then
      intro.text = 2
    end
    if intro.text > 1 and intro.text < 7 then
      intro.Timer5 = intro.Timer5 + dt
      if intro.Timer5 > 2 then
        intro.Timer5 = intro.Timer5 - 2
        intro.text = intro.text + 1
      end    
      if intro.Timer5 > 1 then
        intro.padTextY = 2
      end
    end
  end



end

function drawIntro()

  --start and sc0
  if intro.start == true and intro.startEnd == false then
    love.graphics.setColor(intro.Timer0,intro.Timer0,intro.Timer0)
    love.graphics.draw(sc0Bg)
    love.graphics.draw(sc0Obj1,intro.planeteX1*.5,0)
    love.graphics.draw(sc0Obj2,-intro.planeteX1,0)
    
    if intro.sc0 == true and intro.sc0End == false then
      love.graphics.setColor(1,1,1,1)
      love.graphics.setColor(1,0.95,0.95,0.8)
      love.graphics.rectangle("fill",-60+intro.planeteX2*-100,3*intro.planeteX2*-3+6,0.02+intro.planeteS1,0.02+intro.planeteS1)
      love.graphics.draw(sc0Obj3,250+intro.planeteX2*200,250+intro.planeteX2*200,0,1,1)
      love.graphics.rectangle("fill",250+intro.planeteX2*185,250+intro.planeteX2*185,0.8,0.8)
      love.graphics.rectangle("fill",260+intro.planeteX2*175,260+intro.planeteX2*175,0.8,0.8)
      love.graphics.rectangle("fill",260+intro.planeteX2*175,260+intro.planeteX2*175,0.8,0.8)
      love.graphics.rectangle("fill",intro.planeteX2+12,6*intro.planeteX2*20+30,0.4-intro.planeteS1,0.4-intro.planeteS1)
      love.graphics.setColor(1,1,1,1)
    end
  end
  
  --sc1
  if intro.sc1 == true and intro.sc1End == false then
    if intro.Timer < 14.9 then
      love.graphics.draw(sc1Bg.img,sc1Bg.quad[sc1Bg.frameActive])
      if intro.Timer > 9 and intro.Timer1 < 6 then
        love.graphics.draw(sc1Ship.img,sc1Ship.quad[sc1Ship.frameActive])
      end
    else
      love.graphics.draw(sc1City)
      love.graphics.setColor(0.8,0.8,0)
      love.graphics.rectangle("fill",20,13-intro.cityY,1,1)
      love.graphics.setColor(1,1,1)
    end
  end
  
  --sc2
  if intro.sc2 == true and intro.sc2End == false then
    if intro.Timer > 19 and intro.ascY < 80 then
      love.graphics.draw(sc2Bg,0,intro.ascY-80)
      love.graphics.draw(sc2Light,0,intro.ascY-60)
      love.graphics.draw(sc2Light,0,intro.ascY-40)
      love.graphics.draw(sc2Light,0,intro.ascY-20)
      love.graphics.draw(sc2Door.img, sc2Door.quad[sc2Door.frameActive])    
    end
    if intro.ascY >= 80 then
      love.graphics.draw(sc2Bg,0,intro.ascY-80)
      love.graphics.draw(sc2LeftDoor,-intro.ascDoorX)
      love.graphics.draw(sc2RightDoor,intro.ascDoorX)
    end
  end
  
  --sc3
  if intro.sc3 == true and intro.sc3End == false then
    love.graphics.draw(sc3Bg.img,sc3Bg.quad[sc3Bg.frameActive])
  end
  
  --sc4
  if intro.sc4 == true and intro.sc4End == false then
    if intro.Timer < 38 then
      if intro.Timer < 36 then
        love.graphics.draw(sc4Bg1)
      else
        love.graphics.draw(sc4Bg2)
      end
      love.graphics.draw(sc4Obj,intro.doorX)
      if intro.Timer > 33 then
        love.graphics.setColor(0,0.8,0)
        love.graphics.rectangle("fill",9+intro.doorX,5,2,1)
        love.graphics.setColor(0,0.7,0)
        love.graphics.rectangle("fill",9+intro.doorX,6,2,1)
        love.graphics.setColor(1,1,1)
      end
    else
      love.graphics.draw(sc4Bg3)
      if intro.Timer < 44 then
        love.graphics.draw(sc5Obj1,0,intro.padY+20)
        love.graphics.draw(sc5Obj3,0,intro.padY+20)
      else
        love.graphics.draw(sc5Obj2,0,intro.padY+20)
        love.graphics.draw(sc5Obj3,0,intro.padY+20)
      end
    end
    
    if intro.sc5 == true and intro.sc5End == false then
      if intro.text == 1 then
        love.graphics.setColor(1,1,1,0.8)
        love.graphics.print(" Silver Star Corp@   1985",3,3,0,intro.textScale,intro.textScale)
        love.graphics.print(" .",3,5,0,intro.textScale,intro.textScale)
        love.graphics.print(" .",3,7,0,intro.textScale,intro.textScale)
        love.graphics.print(" >/..loading MSG..",3,9,0,intro.textScale,intro.textScale)
        love.graphics.print(" ..!",3,11,0,intro.textScale,intro.textScale)
        love.graphics.setColor(1,1,1,0.4)
        love.graphics.draw(sc5Obj3,0,intro.padY+20)
        love.graphics.setColor(1,1,1,1)
        if intro.Timer4 < 1 then
          love.graphics.setColor(1,1,1,0.5)
          love.graphics.rectangle("fill",8,11,1,2)
          love.graphics.setColor(1,1,1,1)
        end
      end
      if intro.text == 2 then
        love.graphics.setColor(1,1,1,0.8)
        love.graphics.print(" NEW MESSAGE   (7!)-",3,3,0,intro.textScale,intro.textScale)
        love.graphics.print(" rent not paid (5!)@c.hahi",3,5,0,intro.textScale,intro.textScale)
        love.graphics.print(" rent not paid (4!)@c.hahi",3,7,0,intro.textScale,intro.textScale)
        love.graphics.print(" --N. 421337 ---(!)@k.lunar",3,9,0,intro.textScale,intro.textScale)
        love.graphics.print(" rent not paid (3!)@c.hahi",3,11,0,intro.textScale,intro.textScale)
        love.graphics.setColor(1,1,1,0.5)
        love.graphics.rectangle("fill",3,5+intro.padTextY,24.5,2)
        love.graphics.setColor(1,1,1,0.4)
        love.graphics.draw(sc5Obj3,0,intro.padY+20)
        love.graphics.setColor(1,1,1,1)
      end
      if intro.text == 3 then
        love.graphics.setColor(1,1,1,0.8)
        love.graphics.print(" NEW MESSAGE   (7!)-",3,3,0,intro.textScale,intro.textScale)
        love.graphics.print(" rent not paid (4!)@c.hahi",3,5,0,intro.textScale,intro.textScale)
        love.graphics.print(" --N. 421337 ---(!)@k.lunar",3,7,0,intro.textScale,intro.textScale)
        love.graphics.print(" rent not paid (3!)@c.hahi",3,9,0,intro.textScale,intro.textScale)
        love.graphics.print(" ! A gift for Y (!)@s.pam",3,11,0,intro.textScale,intro.textScale)
        love.graphics.setColor(1,1,1,0.5)
        love.graphics.rectangle("fill",3,5+intro.padTextY,24.5,2)
        love.graphics.setColor(1,1,1,0.4)
        love.graphics.draw(sc5Obj3,0,intro.padY+20)
        love.graphics.setColor(1,1,1,1)
      end
      if intro.text == 4 then
        love.graphics.setColor(1,1,1,0.8)
        love.graphics.print(" NEW MESSAGE   (7!)-",3,3,0,intro.textScale,intro.textScale)
        love.graphics.print(" --N. 421337 ---(!)@k.lunar",3,5,0,intro.textScale,intro.textScale)
        love.graphics.print(" rent not paid (3!)@c.hahi",3,7,0,intro.textScale,intro.textScale)
        love.graphics.print(" ! A gift for Y (!)@s.pam",3,9,0,intro.textScale,intro.textScale)
        love.graphics.print(" rent not paid (2!)@c.hahi",3,11,0,intro.textScale,intro.textScale)
        love.graphics.setColor(1,1,1,0.5)
        love.graphics.rectangle("fill",3,5+intro.padTextY,24.5,2)
        love.graphics.setColor(1,1,1,0.4)
        love.graphics.draw(sc5Obj3,0,intro.padY+20)
        love.graphics.setColor(1,1,1,1)
      end
      if intro.text == 5 then
        love.graphics.setColor(1,1,1,0.8)
        love.graphics.print(" NEW MESSAGE   (7!)-",3,3,0,intro.textScale,intro.textScale)
        love.graphics.print(" rent not paid (4!)@c.hahi",3,5,0,intro.textScale,intro.textScale)
        love.graphics.print(" --N. 421337 ---(!)@k.lunar",3,7,0,intro.textScale,intro.textScale)
        love.graphics.print(" rent not paid (3!)@c.hahi",3,9,0,intro.textScale,intro.textScale)
        love.graphics.print(" ! A gift for Y (!)@s.pam",3,11,0,intro.textScale,intro.textScale)
        love.graphics.setColor(1,1,1,0.5)
        love.graphics.rectangle("fill",3,5+intro.padTextY,24.5,2)
        love.graphics.setColor(1,1,1,0.4)
        love.graphics.draw(sc5Obj3,0,intro.padY+20)
        love.graphics.setColor(1,1,1,1)
      end
      if intro.text >= 6 then
        love.graphics.setColor(1,1,1,0.8)
        love.graphics.print(" @k.lunar : N° 421337 (!)",3,3,0,intro.textScale,intro.textScale)
        love.graphics.print(" Hey! Remember me ? MY debt",3,5,0,intro.textScale,intro.textScale)
        love.graphics.print(" Your first Ship! Old but,",3,7,0,intro.textScale,intro.textScale)
        love.graphics.print(" can be upgrad. Go Hangar 8",3,9,0,intro.textScale,intro.textScale)
        love.graphics.print(" And See ya in SECTOR 5",3,11,0,intro.textScale,intro.textScale)
        love.graphics.setColor(1,1,1,0.5)
        love.graphics.rectangle("fill",3,3,24.5,2)
        love.graphics.setColor(1,1,1,0.4)
        love.graphics.draw(sc5Obj3,0,intro.padY+20)
        love.graphics.setColor(1,1,1,1)
      end
    end
  end
  
  
  --sc6
  if intro.sc6 == true and intro.sc6End == false then
    if intro.Timer >= 68 and intro.Timer < 72 then
      love.graphics.draw(sc6Bg0)
    elseif intro.Timer >= 72 then
      love.graphics.draw(sc6Bg1)
    end
  end

  
--love.graphics.print("@"..intro.Timer,0,0,0,0.1,0.1)

end