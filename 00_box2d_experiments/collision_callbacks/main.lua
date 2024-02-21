if arg[#arg] =="-debug" then require("mobdebug").start() end

function love.load()
  require "physical_shape"
  require "debug_draw"
  
  love.window.setMode(1200, 600)
  love.window.setTitle("Collisions callbacks")
  
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  largeur_drawzone = 800
  hauteur_drawzone = hauteur
  
  world = love.physics.newWorld(0, 100, true)
  world:setCallbacks(Begin_Contact, End_Contact, Presolve, Postsolve)
  text = ""
  persisting = 0
  
  love.physics.setMeter(25)
  metre = love.physics.getMeter()
  
  bordures = {}
  bordures[1] = Create_Edge_Shape(world, largeur_drawzone/2, metre, "static", -metre*15, 0, metre*15, 0)
  bordures[2] = Create_Edge_Shape(world, largeur_drawzone-metre, hauteur_drawzone/2, "static", 0, -metre*11, 0, metre*11)
  bordures[3] = Create_Edge_Shape(world, largeur_drawzone/2, hauteur_drawzone - metre, "static", -metre*15, 0, metre*15, 0)
  bordures[4] = Create_Edge_Shape(world, metre, hauteur_drawzone/2, "static", 0, -metre*11, 0, metre*11)
  bordures[1].fixture:setUserData("haut")
  bordures[2].fixture:setUserData("droite")
  bordures[3].fixture:setUserData("bas")
  bordures[4].fixture:setUserData("gauche")
  
  balle = Create_Circle_Shape(world, largeur_drawzone/2, hauteur_drawzone/2, "dynamic", 15)
  balle.fixture:setRestitution(0.4)
  balle.fixture:setUserData("balle")
  
  sol = Create_Edge_Shape(world, largeur_drawzone/2, hauteur_drawzone-(metre*4), "static", -metre*15, 0, metre*15, 0)
  sol.fixture:setUserData("sol")
  
end

function love.update(dt)
  world:update(dt)
  
  if string.len(text) > 768 then
    text = ""
  end
  
  if love.keyboard.isDown("up") then
    balle.body:applyForce(0, -2500)
  end
  
  if love.keyboard.isDown("right") then
    balle.body:applyForce(1000, 0)
  end
    
  if love.keyboard.isDown("down") then
    balle.body:applyForce(0, 1000)
  end
    
  if love.keyboard.isDown("left") then
    balle.body:applyForce(-1000, 0)
  end
  
end

function love.draw()
  
  love.graphics.setColor(0, 1, 0)
  love.graphics.rectangle("fill", metre, hauteur_drawzone-(metre*4), largeur_drawzone-(metre*2), metre*3)
  love.graphics.setColor(0, 0, 1)
  love.graphics.rectangle("fill", metre, metre, largeur_drawzone-(metre*2), hauteur_drawzone-(metre*5))
  love.graphics.setColor(1, 1, 1)
  
  for i=1,4 do
    --Draw_Edge(bordures[i])
  end
  
  Draw_Circle("fill", balle)
  --Draw_Edge(sol)
  
  love.graphics.print(text, largeur_drawzone, metre)
end

function love.keypressed(key)
  if key == "space" then
    
  end
  
end

function Begin_Contact(a, b, coll)
  x, y = coll:getNormal()
  text = text.."\n"..a:getUserData().." colliding with "..b:getUserData().." with a vector normal of "..x..", "..y
end

function End_Contact(a, b, coll)
  persisting = 0
  text = text.."\n"..a:getUserData().." uncolliding with "..b:getUserData().." with a vector normal of "..x..", "..y
end

function Presolve(a, b, coll)
  if persisting == 0 then
    text = text.."\n"..a:getUserData().." touching "..b:getUserData()
  elseif persisting < 20 then
    text = text.." "..persisting
  end
  persisting = persisting + 1
end

function Postsolve(a, b, coll, normal_impulse, tangent_impulse)
end
