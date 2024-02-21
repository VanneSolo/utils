if arg[#arg] =="-debug" then require("mobdebug").start() end

function love.load()
  require "physical_shape"
  require "debug_draw"
  require "create_tete"
  
  love.window.setMode(1250, 600)
  
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  largeur_drawzone = 800
  hauteur_drawzone = 600
  
  world = love.physics.newWorld(0, 0, true)
  world:setCallbacks(Begin_Contact, End_Contact, Pre_Solve, Post_Solve)
  text = ""
  persisting = 0
  love.physics.setMeter(25)
  metre = love.physics.getMeter()
  
  bordures = {}
  bordures[1] = Create_Edge_Shape(world, largeur_drawzone/2, metre, "static", -metre*15, 0, metre*15, 0)
  bordures[2] = Create_Edge_Shape(world, largeur_drawzone-metre, hauteur_drawzone/2, "static", 0, -metre*11, 0, metre*11)
  bordures[3] = Create_Edge_Shape(world, largeur_drawzone/2, hauteur_drawzone-metre, "static", -metre*15, 0, metre*15, 0)
  bordures[4] = Create_Edge_Shape(world, metre, hauteur_drawzone/2, "static", 0, -metre*11, 0, metre*11)
  for i=1, 4 do
    bordures[i].fixture:setUserData("bordures")
  end
  
  Create_Tete(10)
  Load_Tete(metre*2)
  
end

function love.update(dt)
  world:update(dt)
  framerate = love.timer.getFPS()
  
  if string.len(text) > 768 then
    text = ""
  end
  
  Update_Tete(dt)
  
end

function love.draw()
  for i=1,4 do
    Draw_Edge(bordures[i])
  end
  
  Draw_Tete()
  
  --[[
  for i=1, #balls_physic do
    love.graphics.setColor(1, 0, 0)
    Draw_Circle("line", balls_physic[i])
    love.graphics.setColor(1, 1, 1)
  end
  ]]
  
  love.graphics.print(text, largeur_drawzone-(metre*0.5), metre)
  love.graphics.print("framerate: "..tostring(framerate), metre*1.5, metre*1.5)
end

function Begin_Contact(a, b, coll)
  x, y = coll:getNormal()
  text = text.."\n"..a:getUserData().." is colliding with "..b:getUserData().." with a normal vector of \n"..x..", "..y.."\n"
end

function End_Contact(a, b, coll)
  persisting = 0
  text = text.."\n"..a:getUserData().." is uncolliding with "..b:getUserData().."\n"
end

function Pre_Solve(a, b, coll)
  if persisting == 0 then
    text = text.."\n"..a:getUserData().." is touching "..b:getUserData().."\n"
  elseif persisting < 20 then
    text = text.." "..persisting
  end
  persisting = persisting + 1
end

function Post_Solve(a, b, coll, normal_impulse, tangent_impulse)
  
end