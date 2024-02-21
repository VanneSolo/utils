require "physical_shape"
require "add_fixture"

function Create_Tete()
  
  local classe_tete = {}
  classe_tete.physique = {}
  classe_tete.param_physique = {}
  classe_tete.drawing = {}
  classe_tete.param_drawing = {}
  --classe_tete.update_balls = {}
  classe_tete.param_sensor = {}
  classe_tete.sensor = {}
  classe_tete.drawing_sensor = {}
  classe_tete.param_drawing_sensor = {}
  classe_tete.visible_hostile = {}
  
  
  function classe_tete.Load_Tete(pX, pY, pType, pID, pRotation, pMetre, pCategory, pMask)
    
    local balle = {}
    balle.x = pX
    balle.y = pY
    balle.radius = pMetre
    table.insert(classe_tete.param_physique, balle)
    
    local ball = Create_Circle_Shape(world, balle.x, balle.y, pType, balle.radius)
    ball.body:setAngularVelocity(pRotation)
    ball.fixture:setRestitution(math.random())
    ball.fixture:setUserData(pID)
    ball.fixture:setCategory(pCategory)
    ball.fixture:setMask(pMask)
    table.insert(classe_tete.physique, ball)
    
    visage = love.graphics.newCanvas(balle.radius*2, balle.radius*2)
    table.insert(classe_tete.drawing, visage)
    
    love.graphics.setCanvas(visage)
    local tete = {}
    tete.x = visage:getWidth()
    tete.y = visage:getHeight()
    tete.ox = tete.x/2
    tete.oy = tete.y/2
    tete.contour = love.graphics.circle("line", tete.ox, tete.oy, balle.radius)
    tete.oeil_gauche = love.graphics.rectangle("line", tete.ox-(tete.x*0.17), tete.oy-(tete.y*0.17), 5, 5)
    tete.oeil_droit = love.graphics.rectangle("line", (tete.ox+(tete.x*0.17))-5, tete.oy-(tete.y*0.17), 5, 5)
    tete.bouche = love.graphics.arc("line", "closed", tete.ox, tete.oy+(tete.y*0.1), tete.x/5, -math.pi, -math.pi*2)
    --tete.id = love.graphics.print(ball.fixture:getUserData(), 5, 5, 0, 0.75, 0.75)
    table.insert(classe_tete.param_drawing, tete)
    love.graphics.setCanvas()
  end
  
  --[[
  function classe_tete.Update_Tete(dt)
    
    local local_balls = {}
    local_balls.ball_pos_x, local_balls.ball_pos_y = classe_tete.physique[1].body:getPosition()
    local_balls.ball_angle = classe_tete.physique[1].body:getAngle()
    local_balls.rotation = 0
    local_balls.rotation = local_balls.rotation + local_balls.ball_angle
    table.insert(classe_tete.update_balls, local_balls)
  end
  ]]
  
  
  function classe_tete.Add_Sensor(pRadius, pID, pCategory, pMask)
    
    local sensor_stats = {}
    sensor_stats.radius = pRadius
    table.insert(classe_tete.param_sensor, sensor_stats)
    
    local loc_sensor = Add_Circle_Fixture(classe_tete.physique[1].body, sensor_stats.radius)
    --loc_sensor.rotation = classe_tete.physique[1].body:getAngularVelocity()
    loc_sensor.fixture:setSensor(true)
    loc_sensor.fixture:setCategory(pCategory)
    loc_sensor.fixture:setMask(pMask)
    loc_sensor.fixture:setUserData(pID)
    table.insert(classe_tete.sensor, loc_sensor)
    
    radar_fov = love.graphics.newCanvas(sensor_stats.radius*2, sensor_stats.radius*2)
    table.insert(classe_tete.drawing_sensor, radar_fov)
    
    love.graphics.setCanvas(radar_fov)
    local fov = {}
    fov.x = radar_fov:getWidth()
    fov.y = radar_fov:getHeight()
    fov.ox = fov.x/2
    fov.oy = fov.y/2
    fov.contour = love.graphics.circle("line", fov.ox, fov.oy, sensor_stats.radius)
    fov.origine = love.graphics.line(fov.ox, fov.oy, fov.ox+sensor_stats.radius, fov.oy)
    table.insert(classe_tete.param_drawing_sensor, fov)
    love.graphics.setCanvas()
  end
  
  
  function classe_tete.Draw_Tete(r, g, b, r2, g2, b2)
    
    if #classe_tete.visible_hostile == 0 then
      love.graphics.setColor(r, g, b)
    else
      love.graphics.setColor(r2, g2, b2)
      --[[for i=1,#classe_tete.visible_hostile do
        love.graphics.line(classe_tete.physique[1].body:getX(), classe_tete.physique[1].body:getY(), classe_tete.visible_hostile[i].physique[1].body:getX(), classe_tete.visible_hostile[i].physique[1].body:getY())
      end]]
    end
    love.graphics.draw(classe_tete.drawing[1], classe_tete.physique[1].body:getX(), classe_tete.physique[1].body:getY(), classe_tete.physique[1].body:getAngle(), 1, 1, classe_tete.param_drawing[1].ox, classe_tete.param_drawing[1].oy)
    love.graphics.setColor(1, 1, 1)
  end
  
  
  function classe_tete.Draw_Sensor(r, g, b)
    
    love.graphics.setColor(r, g, b)
    love.graphics.draw(classe_tete.drawing_sensor[1], classe_tete.physique[1].body:getX(), classe_tete.physique[1].body:getY(), classe_tete.physique[1].body:getAngle(), 1, 1, classe_tete.param_drawing_sensor[1].ox, classe_tete.param_drawing_sensor[1].oy)
    love.graphics.setColor(1, 1, 1)
  end
  
  
  function classe_tete.Radar_Spot_Hostile(hostile)
    table.insert(classe_tete.visible_hostile, hostile)
  end
  
  
  function classe_tete.Radar_Lost_Hostile(hostile)
    table.remove(classe_tete.visible_hostile)
  end
  
  
  return classe_tete
end