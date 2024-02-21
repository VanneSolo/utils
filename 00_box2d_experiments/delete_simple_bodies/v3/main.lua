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

  world = love.physics.newWorld(0, 50, true)
  world:setCallbacks(Begin_Contact, End_Contact, Pre_Solve, Post_Solve)

  love.physics.setMeter(25)
  metre = love.physics.getMeter()
  
  bordures = {}
  bordures[1] = Create_Edge_Shape(world, largeur/2, metre, "static", -metre*15, 0, metre*15, 0)
  bordures[2] = Create_Edge_Shape(world, largeur - metre, hauteur/2, "static", 0, -metre*11, 0, metre*11)
  bordures[3] = Create_Edge_Shape(world, largeur/2, hauteur - metre, "static", -metre*15, 0, metre*15, 0)
  bordures[4] = Create_Edge_Shape(world, metre, hauteur/2, "static", 0, -metre*11, 0, metre*11)
  for i=1,#bordures do
    bordures[i].fixture:setUserData("bordure_"..tostring(i))
  end
  
  nombre_balles = 18
  liste_balles = {}
  for i=1,nombre_balles do
    balle = {}
    balle.x = love.math.random(metre*3, largeur-(metre*3))
    balle.y = love.math.random(metre*3, hauteur-(metre*3))
    balle.r = metre
    balle.corps = Create_Circle_Shape(world, balle.x, balle.y, "dynamic", balle.r)
    balle.corps.body:setUserData("balle")
    balle.corps.fixture:setUserData("balle_fixture_"..tostring(i))
    balle.corps.fixture:setRestitution(0.8)
    balle.lifespan = i*2
    balle.chat = false
    balle.mort = false
    table.insert(liste_balles, balle)
  end
  liste_balles[8].chat = true
  --liste_balles[12].chat = true
end

function love.update(dt)
  world:update(dt)
  
  for i=#liste_balles,1,-1 do
    local balle = liste_balles[i]
    if balle.mort == true then
      table.remove(liste_balles, i)
      balle.corps.body:destroy()
    end
  end
  for i=#liste_balles,1,-1 do
    liste_balles[i].corps.fixture:setUserData("balle_fixture_"..tostring(i))
  end
  
end

function love.draw()
  for i=1,#bordures do
    Draw_Edge(bordures[i])
  end
  
  for i=#liste_balles,1,-1 do
    local balle = liste_balles[i]
    if liste_balles[i].chat == true then
      love.graphics.setColor(1, 0, 0)
    else
      love.graphics.setColor(1, 1, 1)
    end
    Draw_Circle("line", balle.corps)
    love.graphics.print(tostring(i), balle.corps.body:getX(), balle.corps.body:getY())
    love.graphics.print("liste_balles["..tostring(i).."] userdata: "..tostring(liste_balles[i].corps.fixture:getUserData()), 30, 30+(i*16))
  end
  
  love.graphics.setColor(1, 1, 1)
end

function Begin_Contact(a, b, coll)
  a_id = a:getUserData()
  a_id_num = tonumber(Find_Pattern(a_id, "%d+"))
  a_id_str = Find_Pattern(a_id, "%D+")
  
  b_id = b:getUserData()
  b_id_num = tonumber(Find_Pattern(b_id, "%d+"))
  b_id_str = Find_Pattern(b_id, "%D+")
  
  a_body = a:getBody():getUserData()
  b_body = b:getBody():getUserData()
  if a_body == "balle" and b_body == "balle" then
    if liste_balles[a_id_num] ~= nil and liste_balles[b_id_num] ~= nil then
      Deviens_Chat(liste_balles[a_id_num], liste_balles[b_id_num])
    end
  end
end

function End_Contact(a, b, coll)
  --[[a_id = a:getUserData()
  a_id_num = tonumber(Find_Pattern(a_id, "%d+"))
  a_id_str = Find_Pattern(a_id, "%D+")
  
  b_id = b:getUserData()
  b_id_num = tonumber(Find_Pattern(b_id, "%d+"))
  b_id_str = Find_Pattern(b_id, "%D+")]]
  
end

function Pre_Solve(a, b, coll)
  
end

function Post_Solve(a, b, coll, normal_impulse, tangent_impulse)
  
end

function Deviens_Chat(a, b)
  if a.chat == true then
    a.mort = true
    b.chat = true
  elseif b.chat == true then
    b.mort = true
    a.chat = true
  end
end

function Find_Pattern(chaine, pattern, start)
  return string.sub(chaine, string.find(chaine, pattern, start))
end