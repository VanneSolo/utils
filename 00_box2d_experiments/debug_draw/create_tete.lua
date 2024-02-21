function Create_Tete()
  
  function Load_Tete()
    nombre_ball = 12
    color_1 = {1, 0, 0}
    color_2 = {0, 1, 0}
  
    balls_physic = {}
    balls_physic_settings = {}
    for i=1,nombre_ball do
      balle = {}
      balle.x = math.random(metre*4, largeur_drawzone-(metre*4))
      balle.y = math.random(metre*4, hauteur_drawzone-(metre*4))
      if i%2 == 0 then
        balle.radius = metre
      else
        balle.radius = metre*2
      end
      ball = Create_Circle_Shape(world, balle.x, balle.y, "dynamic", balle.radius)
      ball.fixture:setRestitution(math.random())
      ball.fixture:setUserData("ball")
      table.insert(balls_physic, ball)
      table.insert(balls_physic_settings, balle)
    end
    
    balls_draw = {}
    balls_draw_settings = {}
    for i=1,nombre_ball do  
      visage = love.graphics.newCanvas(balls_physic_settings[i].radius*2, balls_physic_settings[i].radius*2)
      love.graphics.setCanvas(visage)
      tete = {}
      tete.x = visage:getWidth()
      tete.y = visage:getHeight()
      tete.ox = tete.x/2
      tete.oy = tete.y/2
      if i<7 then
        tete.color = color_1
      else
        tete.color = color_2
      end
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
  
  function Update_Tete(dt)
    update_balls = {}
    for i=1,nombre_ball do
      local_balls = {}
      local_balls.ball_pos_x, local_balls.ball_pos_y = balls_physic[i].body:getPosition()
      local_balls.ball_angle = balls_physic[i].body:getAngle()
      local_balls.rotation = 0
      local_balls.rotation = local_balls.rotation + local_balls.ball_angle
      table.insert(update_balls, local_balls)
    end
  end
  
  function Draw_Tete()
    for i=1,nombre_ball do 
      love.graphics.setColor(balls_draw_settings[i].color)
      love.graphics.draw(balls_draw[i], update_balls[i].ball_pos_x, update_balls[i].ball_pos_y, update_balls[i].rotation, 1, 1, balls_draw_settings[i].ox, balls_draw_settings[i].oy)
      love.graphics.setColor(1, 1, 1)
    end
  end
  
end