io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[arg] == "-debug" then require("mobdebug").start() end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function love.load()
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()

  require "physical_shape"
  require "add_fixture"
  require "debug_draw"
  
  DEGTORAD = 0.0174532925199432957
  RADTODEG = 57.295779513082320876

  world = love.physics.newWorld(0, 0, true)
  
  is_clicked = false
  is_drag = false
  is_released = false
  
  mouse_down_pos_x = 0
  mouse_down_pos_y = 0
  mouse_up_pos_x = 0
  mouse_up_pos_y = 0
  
  love.physics.setMeter(25)
  metre = love.physics.getMeter()
  
  bordures = {}
  bordures[1] = Create_Rect_Shape(world, largeur/2, metre/2, "static", metre*30, metre)
  bordures[2] = Create_Rect_Shape(world, largeur-(metre/2), hauteur/2, "static", metre, metre*22)
  bordures[3] = Create_Rect_Shape(world, largeur/2, hauteur-(metre/2), "static", metre*30, metre)
  bordures[4] = Create_Rect_Shape(world, metre/2, hauteur/2, "static", metre, metre*22)
  for i=1,#bordures do
    bordures[i].fixture:setUserData("bordures_"..tostring(i))
  end
  
  liste_rond = {}
  for i=1,5 do
    local rond = {}
    rond.x = math.random(metre*3, largeur-metre*3)
    rond.y = math.random(metre*3, hauteur-metre*3)
    rond.r = metre
    rond.c = Create_Circle_Shape(world, rond.x, rond.y, "dynamic", rond.r)
    rond.c.fixture:setUserData("rond_"..tostring(i))
    table.insert(liste_rond, rond)
  end
  liste_carre = {}
  for i=1,5 do
    local carre = {}
    carre.x = math.random(metre*3, largeur-metre*3)
    carre.y = math.random(metre*3, hauteur-metre*3)
    carre.t = metre*2
    carre.c = Create_Rect_Shape(world, carre.x, carre.y, "dynamic", carre.t, carre.t)
    carre.c.fixture:setUserData("carre_"..tostring(i))
    table.insert(liste_carre, carre)
  end
  
  liste_bodies = world:getBodies()
  liste_fixtures = {}
  for i=1,#liste_bodies do
    local fixt = liste_bodies[i]:getFixtures()
    table.insert(liste_fixtures, fixt)
  end
  
  found_bodies = {}
  fixtures_aabb = {}
end

Trouve_Fixtures = function(liste_fixtures)
    local corps = liste_fixtures:getBody()
    table.insert(found_bodies, corps)
    local aabb = {}
    aabb.x, aabb.y, aabb.w, aabb.h = liste_fixtures:getBoundingBox()
    table.insert(fixtures_aabb, aabb)
    return true
end

function love.update(dt)
  
  world:update(dt)
  souris_x, souris_y = love.mouse.getPosition()
  rect = {}
  if is_clicked and is_released then
    local points = {}
    points.lower_x = math.min(mouse_down_pos_x, mouse_up_pos_x)
    points.lower_y = math.min(mouse_down_pos_y, mouse_up_pos_y)
    points.upper_x = math.max(mouse_down_pos_x, mouse_up_pos_x)
    points.upper_y = math.max(mouse_down_pos_y, mouse_up_pos_y)
    table.insert(rect, points)
  end
  
  if #rect ~= 0 then
    local p = rect[1]
    world:queryBoundingBox(p.lower_x, p.lower_y, p.upper_x, p.upper_y, Trouve_Fixtures)
  end
end

function love.draw()
  for i=1,#bordures do
    Draw_Rect_Or_Poly("line", bordures[i])
    love.graphics.print(tostring(bordures[i].fixture:getUserData()), bordures[i].body:getX(), bordures[i].body:getY())
  end
  
  for i=1,5 do
    local rond = liste_rond[i]
    Draw_Circle("line", rond.c)
    love.graphics.print(tostring(rond.c.fixture:getUserData()), rond.c.body:getX(), rond.c.body:getY())
    bbx, bby, bbw, bbh = rond.c.fixture:getBoundingBox()
    love.graphics.setColor(1, 1, 0)
    love.graphics.rectangle("line", bbx, bby, bbw-bbx, bbh-bby)
    love.graphics.setColor(1, 1, 1)
  end
  for i=1,5 do
    local carre = liste_carre[i]
    Draw_Rect_Or_Poly("line", carre.c)
    love.graphics.print(tostring(carre.c.fixture:getUserData()), carre.c.body:getX(), carre.c.body:getY())
    cbbx, cbby, cbbw, cbbh = carre.c.fixture:getBoundingBox()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("line", cbbx, cbby, cbbw-cbbx, cbbh-cbby)
    love.graphics.setColor(1, 1, 1)
  end
  
  love.graphics.setColor(0, 0.6, 0.15)
  if is_drag == true then
    love.graphics.line(origin_x, origin_y, souris_x, origin_y)
    love.graphics.line(souris_x, origin_y, souris_x, souris_y)
    love.graphics.line(origin_x, origin_y, origin_x, souris_y)
    love.graphics.line(origin_x, souris_y, souris_x, souris_y)
  end
  love.graphics.setColor(0, 0, 1, 0.1)
  if #rect ~= 0 then
    for i=1,#found_bodies do
      local pos = {}
      pos.x = found_bodies[i]:getX()
      pos.y = found_bodies[i]:getY()
      love.graphics.circle("fill", pos.x, pos.y, 3)
    end
    love.graphics.setColor(1, 0, 1, 0.1)
    for i=1,#fixtures_aabb do
      local bb = fixtures_aabb[i]
      love.graphics.circle("fill", bb.x, bb.y, 3)
      love.graphics.circle("fill", bb.w, bb.y, 3)
      love.graphics.circle("fill", bb.x, bb.h, 3)
      love.graphics.circle("fill", bb.w, bb.h, 3)
    end
  end
  love.graphics.setColor(1, 1, 1, 1)
end

function love.mousepressed(x, y, button)
  rect = {}
  found_bodies = {}
  fixtures_aabb = {}
  is_released = false
  if button == 1 then
    is_clicked = true
    is_drag = true
    mouse_down_pos_x = x
    mouse_down_pos_y = y
    mouse_up_pos_x = mouse_down_pos_x
    mouse_up_pos_y = mouse_down_pos_y
    origin_x = x
    origin_y = y
  end
end

function love.mousereleased(x, y, button)
  if button == 1 then
    is_released = true
    is_drag = false
    mouse_up_pos_x = x
    mouse_up_pos_y = y
  end
end