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

  world = love.physics.newWorld(0, 20, true)
  world:setCallbacks(Begin_Contact, End_Contact, Pre_Solve, Post_Solve)

  love.physics.setMeter(25)
  metre = love.physics.getMeter()
  
  fixtures_under_foot = {}
  liste_bodies = {}
  
  bordure_top = {}
  bordure_top.corps = Create_Rect_Shape(world, largeur/2, metre/2, "static", metre*30, metre)
  bordure_top.corps.fixture:setUserData("bordure_1")
  
  bordure_right = {}
  bordure_right.corps = Create_Rect_Shape(world, largeur-(metre/2), hauteur/2, "static", metre, metre*22)
  bordure_right.corps.fixture:setUserData("bordure_2")
  
  bordure_bas = {}
  bordure_bas.corps = Create_Rect_Shape(world, largeur/2, hauteur-(metre/2), "static", metre*30, metre)
  bordure_bas.corps.fixture:setUserData("bordure_3")
  
  bordure_gauche = {}
  bordure_gauche.corps = Create_Rect_Shape(world, metre/2, hauteur/2, "static", metre, metre*22)
  bordure_gauche.corps.fixture:setUserData("bordure_4")  
  
  grande_boite = {}
  for i=1,25 do
    local box = {}
    box.x = math.random(metre*3, largeur-(metre*3))
    box.y = math.random(metre*3, hauteur-(metre*3))
    box.corps = Create_Rect_Shape(world, box.x, box.y, "dynamic", metre*2, metre*2)
    box.corps.fixture:setUserData("grand_0")
    table.insert(grande_boite, box)
  end
  
  petite_boite = {}
  for i=1,5 do
    local box = {}
    box.x = love.math.random(metre*3, largeur-(metre*3))
    box.y = love.math.random(metre*3, hauteur-(metre*3))
    box.corps = Create_Rect_Shape(world, box.x, box.y, "dynamic", metre, metre*2)
    box.corps.fixture:setUserData("petit_0")
    table.insert(petite_boite, box)
  end
  
  joueur = {}
  joueur.corps = Create_Rect_Shape(world, largeur/2, hauteur-(metre*1.5), "dynamic", metre*2, metre*4)
  joueur.corps.body:setFixedRotation(true)
  joueur.corps.fixture:setUserData("joueur_1")
  pied = {}
  pied.corps = Add_Rect_Fixture(joueur.corps.body, 0, metre*1.5+2, metre, metre)
  pied.corps.fixture:isSensor(true)
  pied.corps.fixture:setUserData("pied_1")
  
  num_foot_contacts = 0
  timer_nouveau_saut = 0
end

function love.update(dt)
  world:update(dt)
  
  velocite_x, velocite_y = joueur.corps.body:getLinearVelocity()
  force=0
  impulse = 0
  impulse_y=0
  target_velocity = 0
  timer_nouveau_saut = timer_nouveau_saut - dt
  if timer_nouveau_saut <= 0 then
    timer_nouveau_saut = 0
  end
  
  if love.keyboard.isDown("up") then
    target_velocity = (velocite_x) * 0.98
  end
  if love.keyboard.isDown("right") then
    target_velocity = math.min(velocite_x+0.5, 25)
  end
  if love.keyboard.isDown("left") then
    target_velocity = math.max(velocite_x-0.5, -25)
  end
  
  change_velocity = target_velocity - velocite_x
  impulse = joueur.corps.body:getMass() * change_velocity
  joueur.corps.body:applyLinearImpulse(impulse, 0, joueur.corps.body:getWorldCenter())
  
  Can_Jump_Now()
end

function love.draw()
  Draw_Rect_Or_Poly("line", bordure_top.corps)
  Draw_Rect_Or_Poly("line", bordure_right.corps)
  Draw_Rect_Or_Poly("line", bordure_bas.corps)
  Draw_Rect_Or_Poly("line", bordure_gauche.corps)
  
  for i=1,#grande_boite do
    Draw_Rect_Or_Poly("line", grande_boite[i].corps)
  end
  
  for i=1,#petite_boite do
    Draw_Rect_Or_Poly("line", petite_boite[i].corps)
  end
  
  love.graphics.setColor(1, 0, 0)
  Draw_Rect_Or_Poly("line", joueur.corps)
  Draw_Supplemental_Rect_Or_Poly("line", joueur.corps, pied.corps)
  love.graphics.setColor(1, 1, 1)
  
  love.graphics.print(timer_nouveau_saut, 30, 30)
  love.graphics.print(tostring(Can_Jump_Now()), 30, 30+16)
  love.graphics.print(tostring(#fixtures_under_foot), 30, 30+16*2)
end

function love.keypressed(key)
  if key == "space" then
    if Can_Jump_Now() == true then
      joueur.corps.body:applyLinearImpulse(0, joueur.corps.body:getMass()*(-150), joueur.corps.body:getWorldCenter())
      timer_nouveau_saut = 0.5
      
      for i=#fixtures_under_foot,1,-1 do
        impulse_in_player_coords_x = 0
        impulse_in_player_coords_y = metre*1.5+2
        impulse_in_world_coords_x, impulse_in_world_coords_y = joueur.corps.body:getWorldPoint(impulse_in_player_coords_x, impulse_in_player_coords_y)
        liste_bodies[i]:applyLinearImpulse(0, liste_bodies[i]:getMass()*80, impulse_in_world_coords_x, impulse_in_world_coords_y)
        debug = liste_bodies[i]:getFixtures()
        print(debug[1]:getUserData())
      end
    end
  end
end

function Begin_Contact(a, b, coll)
  a_id = a:getUserData()
  a_id_body = a:getBody()
  
  b_id = b:getUserData()
  b_id_body = b:getBody()
  
  if a_id == "pied_1" then
    table.insert(fixtures_under_foot, b_id)
    table.insert(liste_bodies, b_id_body)
  end
  if b_id == "pied_1" then
    table.insert(fixtures_under_foot, a_id)
    table.insert(liste_bodies, a_id_body)
  end
end

function End_Contact(a, b, coll)
  a_id = a:getUserData()
  a_id_body = a:getBody()
  
  b_id = b:getUserData()
  b_id_body = b:getBody()
  
  if a_id == "pied_1" then
    table.remove(fixtures_under_foot)
    table.remove(liste_bodies)
  end
  if b_id == "pied_1" then
    table.remove(fixtures_under_foot)
    table.remove(liste_bodies)
  end
end

function Pre_Solve(a, b, coll)
  
end

function Post_Solve(a, b, coll, normal_impulse, tangent_impulse)
  
end

function Find_Pattern(chaine, pattern, start)
  return string.sub(chaine, string.find(chaine, pattern, start))
end

function Can_Jump_Now()
  if timer_nouveau_saut > 0 then
    return false
  end
  if #fixtures_under_foot ~= 0 then
    for i=#fixtures_under_foot,1 do
      if fixtures_under_foot[i] ~= nil then        
          local usersata = fixtures_under_foot[i]
          if usersata == "bordure_3" or usersata == "grand_0" then
            return true
          end
      end
    end
  end
  return false
end