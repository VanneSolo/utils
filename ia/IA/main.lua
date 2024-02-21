io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[arg] == "-debug" then require("mobdebug").start() end

local ZS = require("zombies_states")

function math.angle(x1, y1, x2, y2) return math.atan2(y2 - y1, x2 - x1) end

function math.dist(x1,y1, x2, y2) return ((x2-x1)^2 + (y2-y1)^2)^0.5 end

lst_sprites = {}
lst_blood = {}
img_blood = love.graphics.newImage("Images/blood.png")
img_alert = love.graphics.newImage("Images/alert.png")
b_debug = false
the_human = {}

function CreateSprites(pLst, pType, pImageFiles, pNbFrames)
  mySprite = {}
  mySprite.type = pType
  mySprite.x = 0
  mySprite.y = 0
  mySprite.vx = 0
  mySprite.vy = 0
  mySprite.isVisible = true
  mySprite.life = 100
  mySprite.images = {}
  mySprite.currentFrame = 1
  
  for i=1, pNbFrames do
    mySprite.images[i] = love.graphics.newImage("Images/"..pImageFiles..tostring(i)..".png")
  end
  
  mySprite.width = mySprite.images[1]:getWidth()
  mySprite.height = mySprite.images[1]:getHeight()
  table.insert(pLst, mySprite)
  return mySprite
end

function CreateZombie()
  myZombie = CreateSprites(lst_sprites, "zombie", "zombiz_", 2)
  myZombie.x = math.random(10, largeur - 10)
  myZombie.y = math.random(10, (hauteur/6)*3)
  myZombie.speed = math.random(5, 50)/50
  myZombie.range = math.random(10, 150)
  myZombie.state = ZS.NONE
end

function UpdateZombie(pZombie, pEntitites)
  if pZombie.state == ZS.NONE then
    pZombie.state = ZS.CHANGEDIR
  elseif pZombie.state == ZS.WALK then
    if (pZombie.x<0 or pZombie.x>largeur or pZombie.y<0 or pZombie.y>hauteur) then
      pZombie.state = ZS.CHANGEDIR
    end
    
    for i, sprite in ipairs(pEntitites) do
      if sprite.type == "human" then
        if math.dist(pZombie.x, pZombie.y, sprite.x, sprite.y) < pZombie.range and sprite.dead == false then
          pZombie.state = ZS.ATTACK
          pZombie.target = sprite
        end
      elseif sprite.type == "zombie" then
        if math.dist(pZombie.x, pZombie.y, sprite.x, sprite.y) < pZombie.range*2 and sprite.state == ZS.BITE then
          pZombie.state = ZS.ATTACK
          pZombie.target = sprite
        end
      end
    end
  elseif pZombie.state == ZS.ATTACK then
    if pZombie.target == nil then
      pZombie.state = ZS.CHANGEDIR
    elseif pZombie.target.dead == true then
      pZombie.state = ZS.CHANGEDIR
    elseif math.dist(pZombie.x, pZombie.y, pZombie.target.x, pZombie.target.y) > pZombie.range * 2 and pZombie.target == "zombie" then
      pZombie.state = ZS.CHANGEDIR
    elseif math.dist(pZombie.x, pZombie.y, pZombie.target.x, pZombie.target.y) > pZombie.range * 2 and pZombie.target == "human" then
      pZombie.state = ZS.CHANGEDIR
    elseif pZombie.target.life <= 0 then
      pZombie.state = ZS.CHANGEDIR
    elseif math.dist(pZombie.x, pZombie.y, pZombie.target.x, pZombie.target.y) < 5 and pZombie.target.type == "human" then
      pZombie.vx = 0
      pZombie.vy = 0
      pZombie.state = ZS.BITE
    elseif math.dist(pZombie.x, pZombie.y, pZombie.target.x, pZombie.target.y) < 25 and pZombie.target.type == "zombie" then
      pZombie.vx = 0
      pZombie.vy = 0
      pZombie.state = ZS.WALK
    else
      tx = pZombie.target.x + math.random(-30, 30)
      ty = pZombie.target.y + math.random(-30, 30)
      angle = math.angle(pZombie.x, pZombie.y, tx, ty)
      pZombie.vx = pZombie.speed * 5 * 60 * math.cos(angle)
      pZombie.vy = pZombie.speed * 5 * 60 * math.sin(angle)
    end
  elseif pZombie.state == ZS.BITE then
    if pZombie.target.life ~= nil then
      pZombie.target.life = pZombie.target.life - 0.1
      if pZombie.target.life <= 0 then
        pZombie.target.isVisible = false
        pZombie.target.life = 0
        pZombie.target.dead = true
        myBody = CreateSprites(lst_sprites, "body", "dead_", 1)
        myBody.x = pZombie.target.x
        myBody.y = pZombie.target.y
        pZombie.state = ZS.CHANGEDIR
      end
      if math.random(1, 5) == 1 then
        myBlood = {}
        myBlood.x = pZombie.target.x + math.random(-10, 10)
        myBlood.y = pZombie.target.y + math.random(-10, 10)
        table.insert(lst_blood, myBlood)
      end
    end
    if math.dist(pZombie.x, pZombie.y, pZombie.target.x, pZombie.target.y) > 5 then
      pZombie.state = ZS.ATTACK
    end
  elseif pZombie.state == ZS.CHANGEDIR then
    angle = math.angle(pZombie.x, pZombie.y, math.random(0, largeur), math.random(0, hauteur))
    pZombie.vx = pZombie.speed * 60 * math.cos(angle)
    pZombie.vy = pZombie.speed * 60 * math.sin(angle)
    pZombie.state = ZS.WALK
  end
end

function love.load()
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  
  the_human = CreateSprites(lst_sprites, "human", "v2_green_roger_", 8)
  the_human.x = largeur/2
  the_human.y = (hauteur/6)*5
  the_human.life = 100
  the_human.dead = false
  
  for n=1, 10 do
    CreateZombie()
  end
end

function love.update(dt)
  for i, sprite in ipairs(lst_sprites) do
    sprite.currentFrame = sprite.currentFrame + 0.1 * 60 * dt
    if sprite.currentFrame >= #sprite.images + 1 then
      sprite.currentFrame = 1
    end
    sprite.x = sprite.x + sprite.vx * dt
    sprite.y = sprite.y + sprite.vy * dt
    if sprite.type == "zombie" then
      UpdateZombie(sprite, lst_sprites)
    end
  end
  
  if love.keyboard.isDown("up") then
    the_human.y = the_human.y - 1 * 60 * dt
  end
  if love.keyboard.isDown("right") then
    the_human.x = the_human.x + 1 * 60 * dt
  end
  if love.keyboard.isDown("down") then
    the_human.y = the_human.y + 1 * 60 * dt
  end
  if love.keyboard.isDown("left") then
    the_human.x = the_human.x - 1 * 60 * dt
  end
end

function love.draw()
  love.graphics.push()
  
  for i, sprite in ipairs(lst_sprites) do
    if sprite.isVisible == true then
      frame = sprite.images[math.floor(sprite.currentFrame)]
      love.graphics.draw(frame, sprite.x, sprite.y)
      if love.keyboard.isDown("d") and sprite.type == "zombie" then
        love.graphics.print(sprite.state, sprite.x-10, sprite.y - sprite.height - 10)
      else
        if sprite.type == "zombie" then
          if sprite.state == ZS.ATTACK then
            love.graphics.draw(img_alert, sprite.x - img_alert:getWidth()/2, sprite.y - sprite.height - 10)
          end
        end
      end
    end
  end
  
  if the_human ~= nil then
    love.graphics.print("Life: "..tostring(math.floor(the_human.life)))
  end
  
  love.graphics.pop()
end

function love.keypressed(key)
  if key == "d" then
    if b_debug == false then
      b_debug = true
    else
      b_debug = false
    end
  end
  
  if key == "escape" then
    love.event.quit()
  end
end