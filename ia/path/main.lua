io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[arg] == "-debug" then require("mobdebug").start() end

function love.load()
  require "vector"
  require "dist"
  
  function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end
  
  love.window.setMode(1000, 800)
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  
  a = NewVector(-20, 350)
  b = NewVector(-100, -275)
  c = NewVector(340, 100)
  
  test = AddVectors(a.x, a.y, b.x, b.y, c.x, c.y)
  
  balle = {}
  balle.x = a.x
  balle.y = a.y
  balle.speed = 90
  balle.angle = math.angle(a.x, a.y, b.x, b.y)
  
  balle2 = {}
  balle2.x = b.x
  balle2.y = b.y
  balle2.speed = 70
  balle2.angle = math.angle(b.x, b.y, c.x, c.y)
  
  balle3 = {}
  balle3.x = c.x
  balle3.y = c.y
  balle3.speed = 75
  balle3.angle = math.angle(c.x, c.y, a.x, a.y)
  
  carre = {}
  carre.x = 0
  carre.y = 0
  carre.side = 20
end

function love.update(dt)
  balle.x = balle.x + balle.speed * dt*math.cos(balle.angle)
  balle.y = balle.y + balle.speed * dt*math.sin(balle.angle)
  
  if balle.x <= b.x and balle.y <= b.y or balle.x >= a.x and balle.y >= b.y then
    balle.speed = balle.speed * -1
  end
  
  balle2.x = balle2.x + balle2.speed * dt*math.cos(balle2.angle)
  balle2.y = balle2.y + balle2.speed * dt*math.sin(balle2.angle)
  
  if balle2.x <= b.x and balle2.y <= b.y or balle2.x >= c.x and balle2.y >= c.y then
    balle2.speed = balle2.speed * -1
  end
  
  balle3.x = balle3.x + balle3.speed * dt*math.cos(balle3.angle)
  balle3.y = balle3.y + balle3.speed * dt*math.sin(balle3.angle)
  
  if balle3.x <= a.x and balle3.y >= a.y or balle3.x >= c.x and balle3.y <= c.y then
    balle3.speed = balle3.speed * -1
  end
  
  if love.keyboard.isDown("up") then
    carre.y = carre.y - 10
  end
  if love.keyboard.isDown("right") then
    carre.x = carre.x + 10
  end
  if love.keyboard.isDown("down") then
    carre.y = carre.y + 10
  end
  if love.keyboard.isDown("left") then
    carre.x = carre.x - 10
  end
end

function love.draw()
  for i=0, largeur, 50 do
    for j=0, hauteur, 50 do
      love.graphics.setColor(0.5, 0.5, 0.5)
      love.graphics.rectangle("line", i, j, 50, 50)
    end
  end
  
  love.graphics.push()
  
  love.graphics.translate(largeur/2, hauteur/2)
  love.graphics.setColor(1, 0, 0)
  love.graphics.circle("fill", 0, 0, 5)
  love.graphics.line(-largeur/2+10, 0, largeur/2-10, 0)
  love.graphics.line(0, -hauteur/2+10, 0, hauteur/2-10)
  
  love.graphics.setColor(0, 1, 1)
  love.graphics.line(a.x, a.y, b.x, b.y)
  love.graphics.line(b.x, b.y, c.x, c.y)
  love.graphics.line(a.x, a.y, test.x, test.y)
  
  love.graphics.setColor(0, 1, 0)
  love.graphics.circle("line", balle.x, balle.y, 10)
  
  love.graphics.setColor(0, 1, 0)
  love.graphics.circle("line", balle2.x, balle2.y, 10)
  
  love.graphics.setColor(0, 1, 0)
  love.graphics.circle("line", balle3.x, balle3.y, 10)
  
  love.graphics.setColor(1, 0, 1)
  love.graphics.rectangle("line", carre.x, carre.y, carre.side, carre.side)
  
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("line", carre.x - 50, carre.y - 50, 120, 120)
  
  love.graphics.pop()
  
  for i=30, 70, 20 do
    for j=30, 130, 20 do
      love.graphics.setColor(1, 1, 0)
      love.graphics.rectangle("line", i, j, 20, 20)
    end
  end
end