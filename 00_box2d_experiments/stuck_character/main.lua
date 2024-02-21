io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[arg] == "-debug" then require("mobdebug").start() end

function love.load()
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()

  require "physical_shape"
  require "add_fixture"
  require "debug_draw"
  
  DEGTORAD = 0.0174532925199432957
  RADTODEG = 57.295779513082320876
  
  gravite_y = 50
  world = love.physics.newWorld(0, gravite_y, true)

  love.physics.setMeter(25)
  metre = love.physics.getMeter()
  
  velocite_x = 0
  
  bordures = {}
  bordures[1] = Create_Edge_Shape(world, largeur/2, metre, "static", -metre*15, 0, metre*15, 0)
  bordures[2] = Create_Edge_Shape(world, largeur-metre, hauteur/2, "static", 0, -metre*11, 0, metre*11)
  bordures[3] = Create_Edge_Shape(world, metre, hauteur/2, "static", 0, -metre*11, 0, metre*11)
  
  tuiles_sol = 30
  tuiles_w = metre
  tuiles_h = metre
  boites = {}
  for i=1,tuiles_sol do
    local carre = Create_Rect_Shape(world, (metre/2)+(metre*i), hauteur-(metre/2), "static", tuiles_w, tuiles_w)
    table.insert(boites, carre)
  end
  
  joueur = {}
  joueur.x = largeur/2 - metre/2
  joueur.y = hauteur-metre
  joueur.w = metre
  joueur.h = metre*2
  joueur.corps = Create_Rect_Shape(world, joueur.x, joueur.y, "dynamic", joueur.w, joueur.h)
  joueur.corps.body:setFixedRotation(true)
  pied = {}
  pied.r = metre*0.5
  pied.corps = Add_Circle_Fixture(joueur.corps.body, 0, metre, pied.r)
end

function love.update(dt)
  world:update(dt)
  
  if love.keyboard.isDown("right") then
    velocite_x = 150
  end
  if love.keyboard.isDown("left") then
    velocite_x = -150
  end
  velocite_x = velocite_x * 0.9
  joueur.corps.body:setLinearVelocity(velocite_x, 0)
  joueur.corps.body:applyLinearImpulse(0, 75)
end

function love.draw()
  for i=1,#bordures do
    Draw_Edge(bordures[i])
  end
  
  for i=1,#boites do
    Draw_Rect_Or_Poly("line", boites[i])
  end
  
  Draw_Rect_Or_Poly("line", joueur.corps)
  love.graphics.circle("line", joueur.corps.body:getX(), joueur.corps.body:getY()+metre, metre*0.5)
end

function love.keypressed(key)
  if key == "space" then
    joueur.corps.body:setLinearVelocity(0, -1500)
    --joueur.corps.body:applyLinearImpulse(0, -2500)
  end
end