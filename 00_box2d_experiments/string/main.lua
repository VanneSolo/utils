io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[arg] == "-debug" then require("mobdebug").start() end

function Find_Pattern(text, pattern, start)
  return string.sub(text, string.find(text, pattern, start))
end

function love.load()
  require "physical_shape"
  require "debug_draw"
  
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  
  world = love.physics.newWorld(0, 0, true)
  world:setCallbacks(beginContact, endContact, preSolve, postSolve)
  love.physics.setMeter(25)
  meter = love.physics.getMeter()
  
  rect_test = {}
  
  for i=1,10 do
    truc = {}
    truc.creer = Create_Rect_Shape(world, i*meter*3, hauteur/2, "static", meter, meter)
    truc.creer.fixture:setUserData("carre "..tostring(i))
    table.insert(rect_test, truc)
  end
  
  stock_truc_id = {}
  
  joueur = {}
  joueur.creer = Create_Rect_Shape(world, largeur/2, meter*15, "dynamic", meter, meter)
  joueur.creer.body:setFixedRotation(true)
  joueur.creer.fixture:setUserData("joueur")
end

function love.update(dt)
  world:update(dt)
  --souris_x, souris_y = love.mouse.getPosition()
  
  --joueur.creer.body:setPosition(souris_x, souris_y)
  
  if love.keyboard.isDown("up") then
    joueur.creer.body:setLinearVelocity(0, -50)
  elseif love.keyboard.isDown("right") then
    joueur.creer.body:setLinearVelocity(50, 0)
  elseif love.keyboard.isDown("down") then
    joueur.creer.body:setLinearVelocity(0, 50)
  elseif love.keyboard.isDown("left") then
    joueur.creer.body:setLinearVelocity(-50, 0)
  else
    joueur.creer.body:setLinearVelocity(0, 0)
  end
end

function love.draw()
  for i=1,10 do
    if #stock_truc_id == 0 then
      love.graphics.setColor(1, 1, 1)
    else
      love.graphics.setColor(1, 1, 0)
    end
    Draw_Rect_Or_Poly("line", rect_test[i].creer)
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(rect_test[i].creer.fixture:getUserData(), rect_test[i].creer.body:getX()-meter, meter*10.5)
  end
  
  Draw_Rect_Or_Poly("fill", joueur.creer)
end

function beginContact(pCarre, pJoueur, coll)
  id = pCarre:getUserData()
  num_id = tonumber(Find_Pattern(id, "%d+"))
  table.insert(stock_truc_id, num_id)
end

function endContact(a, b, coll)
  table.remove(stock_truc_id)
end

function preSolve(a, b, coll)
end

function postSolve(a, b, coll, normal_impulse, tangent_impulse)
end