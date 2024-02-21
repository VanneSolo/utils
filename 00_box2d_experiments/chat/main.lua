if arg[arg] == "-debug" then require("mobdebug").start() end
io.stdout:setvbuf('no')

function love.load()
  require "physical_shape"
  
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  
  world = love.physics.newWorld(0, 10, true)
  love.physics.setMeter(25)
  metre = love.physics.getMeter()
  world:setCallbacks(Begin_Contact, End_Contact, Pre_Solve, Post_Solve)
  
  liste_tete_morte = {}
  timer_remove = 1
  
  bordures = {}
  bordures[1] = Create_Edge_Shape(world, largeur/2, metre, "static", -metre*15, 0, metre*15, 0)
  bordures[2] = Create_Edge_Shape(world, largeur-metre, hauteur/2, "static", 0, -metre*11, 0, metre*11)
  bordures[3] = Create_Edge_Shape(world, largeur/2, hauteur - metre, "static", -metre*15, 0, metre*15, 0)
  bordures[4] = Create_Edge_Shape(world, metre, hauteur/2, "static", 0, -metre*11, 0, metre*11)
  for i=1,#bordures do
    bordures[i].fixture:setUserData("bordure_"..tostring(i))
  end
  
  nombre_ball = 10
  
  balls_physic = {}
  balls_physic_settings = {}
  for i=1, nombre_ball do
    balle = {}
    balle.x = math.random(metre*4, largeur-(metre*4))
    balle.y = math.random(metre*4, hauteur-(metre*4))
    balle.radius = math.random(metre, metre*2)
    balle.chat = false
    ball = Create_Circle_Shape(world, balle.x, balle.y, "dynamic", balle.radius)
    ball.fixture:setRestitution(1)
    table.insert(balls_physic, ball)
    table.insert(balls_physic_settings, balle)
  end
  for i=1,#balls_physic do
    balls_physic[i].fixture:setUserData("tete_"..tostring(i))
  end
  balls_physic_settings[1].chat = true
  
  balls_draw = {}
  balls_draw_settings = {}
  for i=1, nombre_ball do  
    visage = love.graphics.newCanvas(balls_physic_settings[i].radius*2, balls_physic_settings[i].radius*2)
    love.graphics.setCanvas(visage)
    tete = {}
    tete.x = visage:getWidth()
    tete.y = visage:getHeight()
    tete.ox = tete.x/2
    tete.oy = tete.y/2
    tete.contour = love.graphics.circle("line", tete.ox, tete.oy, balls_physic_settings[i].radius)
    tete.oeil_gauche = love.graphics.rectangle("line", tete.ox-(tete.x*0.17), tete.oy-(tete.y*0.17), 5, 5)
    tete.oeil_droit = love.graphics.rectangle("line", (tete.ox+(tete.x*0.17))-5, tete.oy-(tete.y*0.17), 5, 5)
    tete.bouche = love.graphics.arc("line", "closed", tete.ox, tete.oy+(tete.y*0.1), tete.x/5, -math.pi, -math.pi*2)
    --love.graphics.points(tete.ox, tete.oy)
    --love.graphics.rectangle("line", 0, 0, tete.x, tete.y)
    --love.graphics.line(tete.ox, tete.oy, 0, 0)
    love.graphics.setCanvas()
    table.insert(balls_draw, visage)
    table.insert(balls_draw_settings, tete)
  end
  
end

function love.update(dt)
  world:update(dt)
  timer_remove = timer_remove - dt
  if timer_remove <= 0 then
    timer_remove = 1
  end
  
  update_balls = {}
  for i=1,#balls_physic do
    local_balls = {}
    local_balls.ball_pos_x, local_balls.ball_pos_y = balls_physic[i].body:getPosition()
    local_balls.ball_angle = balls_physic[i].body:getAngle()
    local_balls.rotation = 0
    local_balls.rotation = local_balls.rotation + local_balls.ball_angle
    table.insert(update_balls, local_balls)
  end
  
end

function love.draw()
  for i=1,4 do
    Draw_Edge(bordures[i])
    love.graphics.print(bordures[i].fixture:getUserData(), bordures[i].body:getX(), bordures[i].body:getY())
  end
  
  for i=1,#balls_physic do
    if balls_physic_settings[i].chat == true then
      love.graphics.setColor(1, 0, 0)
    else
      love.graphics.setColor(1, 1, 1)
    end
    love.graphics.draw(balls_draw[i], update_balls[i].ball_pos_x, update_balls[i].ball_pos_y, update_balls[i].rotation, 1, 1, balls_draw_settings[i].ox, balls_draw_settings[i].oy)
    love.graphics.print(tostring(balls_physic[i].fixture:getUserData()), balls_physic[i].body:getX(), balls_physic[i].body:getY())
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
  
  if a_id_str == "tete_" and b_id_str == "tete_" then
    Deviens_Chat(balls_physic_settings[a_id_num], balls_physic_settings[b_id_num])
  end
  
end

function End_Contact(a, b, coll)
  a_id = a:getUserData()
  a_id_num = tonumber(Find_Pattern(a_id, "%d+"))
  a_id_str = Find_Pattern(a_id, "%D+")
  
  b_id = b:getUserData()
  b_id_num = tonumber(Find_Pattern(b_id, "%d+"))
  b_id_str = Find_Pattern(b_id, "%D+")
  
end

function Pre_Solve(a, b, coll)
  
end

function Post_Solve(a, b, coll, normal_input, tangent_input)
  for i=#liste_tete_morte,1,-1 do
    --print(timer_remove)
    if timer_remove <= 0.05 then
      table.remove(liste_tete_morte, i)
      table.remove(balls_physic, i)
      --table.remove(balls_physic_settings, i)
      table.remove(balls_draw, i)
      table.remove(balls_draw_settings, i)
      --table.remove(update_balls, i)
    end
  end
end

function Find_Pattern(chaine, pattern, start)
  return string.sub(chaine, string.find(chaine, pattern, start))
end

function Deviens_Chat(p_Balle_1, p_Balle_2)
  if p_Balle_1.chat == true then
    table.insert(liste_tete_morte, p_Balle_1.chat)
    p_Balle_2.chat = true
  elseif p_Balle_2.chat == true then
    table.insert(liste_tete_morte, p_Balle_2.chat)
    p_Balle_1.chat = true
  end
end