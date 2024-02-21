-- Création d'un rectangle.
function Create_Rect(x, y, w, h, dir)
  local ghost = {}
  ghost.position = Vector(x, y)
  ghost.size = Vector(w, h)
  ghost.velocite = Vector(0, 0)
  
  ghost.haut = {x1=ghost.position.x, y1=ghost.position.y, x2=ghost.position.x+ghost.size.x, y2=ghost.position.y}
  ghost.droite = {x1=ghost.position.x+ghost.size.x, y1=ghost.position.y, x2=ghost.position.x+ghost.size.x, y2=ghost.position.y+ghost.size.y}
  ghost.bas = {x1=ghost.position.x, y1=ghost.position.y+ghost.size.y, x2=ghost.position.x+ghost.size.x, y2=ghost.position.y+ghost.size.y}
  ghost.gauche = {x1=ghost.position.x, y1=ghost.position.y, x2=ghost.position.x, y2=ghost.position.y+ghost.size.y}
  
  if dir then
    ghost.direction = {x1=ghost.position.x+ghost.size.x/2, y1=ghost.position.y+ghost.size.y/2, x2=ghost.position.x+ghost.size.x/2+ghost.velocite.x, y2=ghost.position.y+ghost.size.y+ghost.velocite.y}
  end
  
  ghost.verticies = {}
  ghost.verticies[1] = Vector(ghost.position.x, ghost.position.y)
  ghost.verticies[2] = Vector(ghost.position.x+ghost.size.x, ghost.position.y)
  ghost.verticies[3] = Vector(ghost.position.x+ghost.size.x, ghost.position.y+ghost.size.y)
  ghost.verticies[4] = Vector(ghost.position.x, ghost.position.y+ghost.size.y)
  ------------------------------------------------------------------------------------------------------
  ghost.Update = function(dt)
    ghost.haut = {x1=ghost.position.x, y1=ghost.position.y, x2=ghost.position.x+ghost.size.x, y2=ghost.position.y}
    ghost.droite = {x1=ghost.position.x+ghost.size.x, y1=ghost.position.y, x2=ghost.position.x+ghost.size.x, y2=ghost.position.y+ghost.size.y}
    ghost.bas = {x1=ghost.position.x, y1=ghost.position.y+ghost.size.y, x2=ghost.position.x+ghost.size.x, y2=ghost.position.y+ghost.size.y}
    ghost.gauche = {x1=ghost.position.x, y1=ghost.position.y, x2=ghost.position.x, y2=ghost.position.y+ghost.size.y}
    if dir then
      ghost.direction = {x1=ghost.position.x+ghost.size.x/2, y1=ghost.position.y+ghost.size.y/2, x2=ghost.position.x+ghost.size.x/2+ghost.velocite.x, y2=ghost.position.y+ghost.size.y/2+ghost.velocite.y}
    end
    ghost.verticies[1] = Vector(ghost.position.x, ghost.position.y)
    ghost.verticies[2] = Vector(ghost.position.x+ghost.size.x, ghost.position.y)
    ghost.verticies[3] = Vector(ghost.position.x+ghost.size.x, ghost.position.y+ghost.size.y)
    ghost.verticies[4] = Vector(ghost.position.x, ghost.position.y+ghost.size.y)
  end
  -------------------------------------------------------------------------------------------------------
  ghost.Draw = function()
    love.graphics.line(ghost.haut.x1, ghost.haut.y1, ghost.haut.x2, ghost.haut.y2)
    love.graphics.line(ghost.droite.x1, ghost.droite.y1, ghost.droite.x2, ghost.droite.y2)
    love.graphics.line(ghost.bas.x1, ghost.bas.y1, ghost.bas.x2, ghost.bas.y2)
    love.graphics.line(ghost.gauche.x1, ghost.gauche.y1, ghost.gauche.x2, ghost.gauche.y2)
    if dir then
      love.graphics.setColor(1, 0, 0)
      love.graphics.line(ghost.direction.x1, ghost.direction.y1, ghost.direction.x2, ghost.direction.y2)
      love.graphics.setColor(1, 1, 1)
    end
  end
  return ghost
end


-- Création d'un polygone.
function Create_Polygon(table_point, pos_x, pos_y, angle, pid)
  local ghost = {}
  ghost.verticies = {}
  ghost.forme = table_point
  ghost.position = Vector(pos_x, pos_y)
  ghost.angle = angle
  ghost.overlap = false
  ghost.ID = pid
  
  ghost.Update = function(dt)
    ghost.verticies = {}
    for j=1,#ghost.forme do
      local p = Vector(
        (ghost.forme[j].x*math.cos(ghost.angle)) - (ghost.forme[j].y*math.sin(ghost.angle)) + ghost.position.x,
        (ghost.forme[j].x*math.sin(ghost.angle)) + (ghost.forme[j].y*math.cos(ghost.angle)) + ghost.position.y
      )
      table.insert(ghost.verticies, p)
    end
    ghost.overlap = false
  end
  ghost.Draw = function()
    for i=1,#ghost.verticies do
      if i == #ghost.verticies then
        love.graphics.line(ghost.verticies[i].x, ghost.verticies[i].y, ghost.verticies[1].x, ghost.verticies[1].y)
      else
        love.graphics.line(ghost.verticies[i].x, ghost.verticies[i].y, ghost.verticies[i+1].x, ghost.verticies[i+1].y)
      end
    end
    love.graphics.points(ghost.position.x, ghost.position.y)
  end
  return ghost
end

function Create_Poly_Points(nb_points, rayon, rotation)
  local angle = (math.pi*2) / nb_points
  local poly_verts = {}
  for i=1,nb_points do
    local verts = Vector(rayon*math.cos(angle*i + rotation), rayon*math.sin(angle*i + rotation))
    table.insert(poly_verts, verts)
  end
  return poly_verts
end