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
  
  liste_balles_mortes = {}
  nombre_balle = 10
  liste_balles = {}
  for i=1,nombre_balle do
    balle = {}
    balle.x = math.random(metre*3, largeur-(metre*3))
    balle.y = math.random(metre*3, hauteur-(metre*3))
    balle.virus = false
    balle.corps = Create_Circle_Shape(world, balle.x, balle.y, "dynamic", metre)
    balle.corps.fixture:setUserData("balle_"..tostring(i))
    balle.corps.fixture:setRestitution(1)
    table.insert(liste_balles, balle)
  end
  liste_balles[1].virus = true
end

function love.update(dt)
  world:update(dt)
end

function love.draw()
  for i=1,#bordures do
    Draw_Edge(bordures[i])
  end
  
  for i=1,#liste_balles do
    if liste_balles[i].virus == true then
      love.graphics.setColor(1, 0, 0)
    else
      love.graphics.setColor(1, 1, 1)
    end
    Draw_Circle("line", liste_balles[i].corps)
    love.graphics.print(liste_balles[i].corps.fixture:getUserData(), liste_balles[i].corps.body:getX()-20, liste_balles[i].corps.body:getY())
    love.graphics.print(liste_balles[i].corps.fixture:getUserData().." "..tostring(liste_balles[i].virus), 30, 30+(i*16))
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
  
  if a_id_str == "balle_" and b_id_str == "balle_" then
    Deviens_Chat(liste_balles[a_id_num], liste_balles[b_id_num])
  end
end

function End_Contact(a, b, coll)
  a_id = a:getUserData()
  a_id_num = Find_Pattern(a_id, "%d+")
  a_id_str = Find_Pattern(a_id, "%D+")
  
  b_id = b:getUserData()
  b_id_num = Find_Pattern(b_id, "%d+")
  b_id_str = Find_Pattern(b_id, "%D+")
end

function Pre_Solve(a, b, coll)
  
end

function Post_Solve(a, b, coll, normal_impulse, tangent_impulse)
  
end

function Deviens_Chat(a, b)
  temp = a.virus
  a.virus = b.virus
  b.virus = temp
end

function Find_Pattern(chaine, pattern, start)
  return string.sub(chaine, string.find(chaine, pattern, start))
end