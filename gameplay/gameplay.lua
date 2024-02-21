-- Bouge le sprite du joueur.
function Move_Player_2(forward, part)
  thrusting = false
  turning_right = false
  turning_left = false
  
  if love.keyboard.isDown("up") then
    thrusting = true
  end
  if love.keyboard.isDown("right") then
    turning_right = true
  end
  if love.keyboard.isDown("left") then
    turning_left = true
  end
  
  if thrusting then
    forward.Set_Norme(0.1)
  else
    forward.Set_Norme(0)
  end
  if turning_right then
    part.rotation = part.rotation + 0.05
  end
  if turning_left then
    part.rotation = part.rotation - 0.05
  end
  
  forward.Set_Angle(part.rotation)
  part.Accelerate(forward)
end


---------------------------

-- Déplacer un joueur avec les flèches directionnelles.
function Move_Player(p_entity, p_speed, dt)
  p_entity.velocite = Vector(0, 0)
  if love.keyboard.isDown("up") then
    p_entity.velocite = p_entity.velocite + (Vector(0, -p_speed))
  end
  if love.keyboard.isDown("right") then
    p_entity.velocite = p_entity.velocite + (Vector(p_speed, 0))
  end
  if love.keyboard.isDown("down") then
    p_entity.velocite = p_entity.velocite + (Vector(0, p_speed))
  end
  if love.keyboard.isDown("left") then
    p_entity.velocite = p_entity.velocite + (Vector(-p_speed, 0))
  end
  if p_entity.velocite.Get_Norme() ~= 0 then
    p_entity.velocite.normalize()
    p_entity.velocite.Multiply_By(p_speed)
  end
  p_entity.position.Add_To(p_entity.velocite*dt)
end

-- Bouge et tourne un sprite
function Rotate_And_Move(object, forward, backward, angle_up, angle_down, dt)
  if love.keyboard.isDown(angle_up) then
    object.angle = object.angle + 2*dt
  end
  if love.keyboard.isDown(angle_down) then
    object.angle = object.angle - 2*dt
  end
  
  if love.keyboard.isDown(forward) then
    object.position.x = object.position.x + math.cos(object.angle) * 60*dt
    object.position.y = object.position.y + math.sin(object.angle) * 60*dt
  end
  if love.keyboard.isDown(backward) then
    object.position.x = object.position.x - math.cos(object.angle) * 60*dt
    object.position.y = object.position.y - math.sin(object.angle) * 60*dt
  end
end