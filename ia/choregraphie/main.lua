io.stdout:setvbuf('no')
if arg[arg] == "-debug" then require("mobdebug").start() end
love.graphics.setDefaultFilter("nearest")

require "choregraphie"
require "direction"

largeur = 0
hauteur = 0
general_speed = 5
vaisseau = {}

function Init_Chrono()
  chrono = 5
  chrono2 = 5
  decalage = 0.5
end

function love.load()
  love.window.setMode(1024, 768)
  love.window.setTitle("Chorégraphie")
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  
  Init_Chrono()
  
  vaisseau = {}
  vaisseau.img = love.graphics.newCanvas(40, 40)
  vaisseau.w = vaisseau.img:getWidth()
  vaisseau.h = vaisseau.img:getHeight()
  vaisseau.x = largeur
  vaisseau.y = hauteur/2 - vaisseau.h/2
  vaisseau.vx = 0
  vaisseau.vy = 0
  
  love.graphics.setCanvas(vaisseau.img)
  love.graphics.setColor(1, 0, 0)
  love.graphics.polygon("fill", 0, 20, 40, 0, 40, 40)
  love.graphics.setColor(1, 1, 1)
  love.graphics.setCanvas()
  
  
  vaisseau2 = {}
  vaisseau2.img = love.graphics.newCanvas(40, 40)
  vaisseau2.w = vaisseau2.img:getWidth()
  vaisseau2.h = vaisseau2.img:getHeight()
  vaisseau2.x = largeur+75
  vaisseau2.y = hauteur/2 - vaisseau2.h/2 - 60
  vaisseau2.vx = 0
  vaisseau2.vy = 0
  
  love.graphics.setCanvas(vaisseau2.img)
  love.graphics.setColor(1, 0, 0)
  love.graphics.polygon("fill", 0, 20, 40, 0, 40, 40)
  love.graphics.setColor(1, 1, 1)
  love.graphics.setCanvas()
end

function love.update(dt)
  -- Décrémentation des timers et appel des patterns des vaisseaux
  Gauche(vaisseau)
  chrono = chrono - dt
  Choregraphie(chrono, vaisseau)
  
  decalage = decalage-dt
  if decalage <= 0 then
    Gauche(vaisseau2)
    chrono2 = chrono2 - dt
    Choregraphie(chrono2, vaisseau2)
  end
  -- Remise à 0 des timers  
  if chrono <= 0 then
    chrono = 5
    vaisseau.x = largeur
    vaisseau.y = hauteur/2 - vaisseau.h/2
  end
  if chrono2 <= 0 then
    chrono2 = 5
    vaisseau2.x = largeur+75
    vaisseau2.y = hauteur/2 - vaisseau2.h/2 - 60
  end
  if decalage <= 0 then
    decalage = 0
  end
  -- MAJ de la position des vaisseaux
  vaisseau.x = vaisseau.x + vaisseau.vx
  vaisseau.y = vaisseau.y + vaisseau.vy
  
  vaisseau2.x = vaisseau2.x + vaisseau2.vx
  vaisseau2.y = vaisseau2.y + vaisseau2.vy
end

function love.draw()
  love.graphics.print("chrono: "..tostring(chrono), 5, 5)
  love.graphics.print("chrono2: "..tostring(chrono2), 5, 5+16)
  love.graphics.print("decalage: "..tostring(decalage), 5, 5+16*2)
  
  love.graphics.print("vaisseau.vx: "..tostring(vaisseau.vx), 200, 5)
  love.graphics.print("vaisseau.vy: "..tostring(vaisseau.vy), 200, 5+16)
  
  love.graphics.print("vaisseau2.vx: "..tostring(vaisseau2.vx), 350, 5)
  love.graphics.print("vaisseau2.vy: "..tostring(vaisseau2.vy), 350, 5+16)
  
  love.graphics.draw(vaisseau.img, vaisseau.x, vaisseau.y)
  love.graphics.draw(vaisseau2.img, vaisseau2.x, vaisseau2.y)
end

function love.keypressed(key)
  if key == "space" then
    vaisseau.x = largeur
    vaisseau.y = hauteur/2 - vaisseau.h/2
    Init_Chrono()
  end
end