-- Fonction qui renvoie si un point se superpose avec un cercle. En paramètres on passe
-- les coordonnées x et y du point et du centre du cercle et le rayon du cercle. On 
-- renvoie vrai si la distance entre les deux opints est inférieure au rayon, sinon on
-- retourne false.
function Point_Vs_Circle(x1, y1, x2, y2, pRayon)
  if Distance(x1, y1, x2, y2) <= pRayon then
    return true
  end
  return false
end

function Circle_Collision(x1, y1, x2, y2, pRayon1, pRayon2)
  if Distance(x1, y1, x2, y2) <= pRayon1+pRayon2 then
    return true
  end
  return false
end

function In_Range(value, pMin, pMax)
  if value >= math.min(pMin, pMax) and value <= math.max(pMin, pMax) then
    return true
  end
  return false
end

function Point_In_Rect(x, y, pRect)
  if In_Range(x, pRect.x, pRect.x+pRect.w) and
    In_Range(y, pRect.y, pRect.y+pRect.h) then
      return true
  end
  return false
end

function Range_Intersect(min_1, max_1, min_2, max_2)
  if math.max(min_1, max_1) >= math.min(min_2, max_2) and
    math.min(min_1, max_1) <= math.max(min_2, max_2) then
      return true
  end
  return false
end

function Rect_Intersect(rect_1, rect_2)
  if Range_Intersect(rect_1.x, rect_1.x+rect_1.w, rect_2.x, rect_2.x+rect_2.w) and
    Range_Intersect(rect_1.y, rect_1.y+rect_1.h, rect_2.y, rect_2.y+rect_2.h) then
      return true
  end
end

-----------------------------------------------------------

-- Collision point vs point.
function Point_Vs_Point(x1, y1, x2, y2)
  if x1 == x2 and y1 == y2 then
    return true
  end
  return false
end

-- Collision point contre cercle.
function Point_Vs_Circle(px, py, cx, cy, rayon)
  local dist_x = cx - px
  local dist_y = cy - py
  local dist = math.sqrt(dist_x*dist_x + dist_y*dist_y)
  if dist < rayon then
    return true
  end
  return false
end

-- Collision cercle vs cercle.
function Circle_Vs_Circle(cx1, cy1, cx2, cy2, r1, r2)
  local dist_x = cx1 - cx2
  local dist_y = cy1 - cy2
  local dist = math.sqrt(dist_x*dist_x + dist_y*dist_y)
  if dist < r1 + r2 then
    return true
  end
  return false
end
-- Collision point contre rectangle.
function Point_Vs_Rect(px, py, rx, ry, rw, rh)
  if px > rx and px < rx+rw and py > ry and py < ry+rh then
    return true
  end
  return false
end

-- Collision rectangle vs rectangle.
function Rect_Vs_Rect(rx1, ry1, rw1, rh1, rx2, ry2, rw2, rh2)
  if rx1+rw1 > rx2 and rx1 < rx2+rw2 and ry1+rh1 > ry2 and ry1 < ry2+rh2 then
    return true
  end
  return false
end

-- Collision cercle vs rectangle.
function Circle_Vs_Rectangle(pcx, pcy, prayon, prx, pry, prw, prh)
  local test_x = pcx
  local test_y = pcy
  
  if pcx < prx then
    test_x = prx
  elseif pcx > prx+prw then
    test_x = prx+prw
  end
  if pcy < pry then
    test_y = pry
  elseif pcy > pry+prh then
    test_y = pry+prh
  end
  
  local dist_x = pcx-test_x
  local dist_y = pcy-test_y
  local dist = math.sqrt(dist_x*dist_x + dist_y*dist_y)
  
  if dist <= prayon then
    return true
  end
  return false
end

-- Collision point vs ligne.
function Point_Vs_Line(ppx, ppy, px1, py1, px2, py2)
  local d1 = Distance(ppx, ppy, px1, py1)
  local d2 = Distance(ppx, ppy, px2, py2)
  local line_length = Distance(px1, py1, px2, py2)
  local buffer = 0.05
  
  if d1+d2 >= line_length-buffer and d1+d2 <= line_length+buffer then
    return true
  end
  return false
end

-- Collision cercle vs line.
function Circle_Vs_Line(pcx, pcy, pr, px1, py1, px2, py2)
  local inside_1 = Point_Vs_Circle(px1, py1, pcx, pcy, pr)
  local inside_2 = Point_Vs_Circle(px2, py2, pcx, pcy, pr)
  if inside_1 or inside_2 then
    return true
  end
  
  local dist_x = px1 - px2
  local dist_y = py1 - py2
  local length = math.sqrt(dist_x*dist_x + dist_y*dist_y)
  local dot = ( ((pcx-px1)*(px2-px1)) + ((pcy-py1)*(py2-py1)) ) / math.pow(length, 2)
  local closest_x = px1 + (dot*(px2-px1))
  local closest_y = py1 + (dot*(py2-py1))
  local on_segment = Point_Vs_Line(closest_x, closest_y, px1, py1, px2, py2)
  if not on_segment then
    return false
  end
  dist_x = closest_x - pcx
  dist_y = closest_y - pcy
  local dist = math.sqrt(dist_x*dist_x + dist_y*dist_y)
  if dist <= pr then
    return true
  end
  return false
end

-- Collision ligne vs ligne.
function Line_Vs_Line(l1p1x,l1p1y, l1p2x,l1p2y, l2p1x,l2p1y, l2p2x,l2p2y, seg1, seg2)
	local a1,b1,a2,b2 = l1p2y-l1p1y, l1p1x-l1p2x, l2p2y-l2p1y, l2p1x-l2p2x
	local c1,c2 = a1*l1p1x+b1*l1p1y, a2*l2p1x+b2*l2p1y
	local det,lx,ly = a1*b2 - a2*b1
	if det==0 then return false, "The lines are parallel." end
	lx,ly = (b2*c1-b1*c2)/det, (a1*c2-a2*c1)/det
	if seg1 or seg2 then
		local min,max = math.min, math.max
		if seg1 and not (min(l1p1x,l1p2x) <= lx and lx <= max(l1p1x,l1p2x) and min(l1p1y,l1p2y) <= ly and ly <= max(l1p1y,l1p2y)) or
		   seg2 and not (min(l2p1x,l2p2x) <= lx and lx <= max(l2p1x,l2p2x) and min(l2p1y,l2p2y) <= ly and ly <= max(l2p1y,l2p2y)) then
			return false, "The lines don't intersect."
		end
	end
	return {x=lx, y=ly}
end

-- Collision ligne vs rectangle.
function Line_Vs_Rectangle(px1, py1, px2, py2, prx, pry, prw, prh)
  local right = Line_Vs_Line(px1, py1, px2, py2, prx+prw, pry, prx+prw, pry+prh, false)
  local down = Line_Vs_Line(px1, py1, px2, py2, prx, pry+prh, prx+prw, pry+prh, false)
  local left = Line_Vs_Line(px1, py1, px2, py2, prx, pry, prx, pry+prh, false)
  local up = Line_Vs_Line(px1, py1, px2, py2, prx, pry, prx+prw, pry, false)
  
  if right or down or left or up then
    return true
  end
  return false
end

-- Collision point vs polygone.
function Point_Vs_Polygon(p_px, p_py, p_table)
  local collision = false
  
  local suivant = 1
  for current=1,#p_table do
    local suivant = current + 1
    if suivant == #p_table+1 then
      suivant = 1
    end
    
    local v_current = p_table[current]
    local v_suivant = p_table[suivant]
    
    if (v_current.y>p_py)~=(v_suivant.y>p_py) and p_px < (v_suivant.x-v_current.x)*(p_py-v_current.y)/(v_suivant.y-v_current.y) + v_current.x then
      collision = not collision
    end
    
  end
  return collision
end

-- Collision cercle vs polygone.
function Circle_Vs_Polygon(p_table, p_cx, p_cy, p_cr)
  local suivant = 1
  for current=1,#p_table do
    suivant = current+1
    if suivant == #p_table+1 then
      suivant = 1
    end
    
    local v_current = p_table[current]
    local v_suivant = p_table[suivant]
    local collision = Circle_Vs_Line(p_cx, p_cy, p_cr, v_current.x, v_current.y, v_suivant.x, v_suivant.y)
    if collision then
      return true
    end
  end
  local center_inside = Point_Vs_Polygon(p_cx, p_cy, p_table)
  if center_inside then
    return true
  end
  return false
end

-- Collision rectangle vs polygone.
function Rect_Vs_Polygon(p_table, px, py, pw, ph)
  local suivant = 1
  for current=1,#p_table do
    suivant = current + 1
    if suivant == #p_table+1 then
      suivant = 1
    end
    local v_current = p_table[current]
    local v_suivant = p_table[suivant]
    local collision = Line_Vs_Rectangle(v_current.x, v_current.y, v_suivant.x, v_suivant.y, px, py, pw, ph)
    if collision then
      return true
    end
    
    local inside = Point_Vs_Polygon(px, py, p_table)
    if inside then
      return true
    end
  end
  return false
end

-- Collision ligne vs polygone.
function Line_Vs_Polygon(p_table, px1, py1, px2, py2, seg1, seg2)
  suivant = 1
  for current=1,#p_table do
    suivant = current+1
    if suivant == #p_table+1 then
      suivant = 1
    end
    
    local x3 = p_table[current].x
    local y3 = p_table[current].y
    local x4 = p_table[suivant].x
    local y4 = p_table[suivant].y
    local collision = Line_Vs_Line(px1, py1, px2, py2, x3, y3, x4, y4, seg1, seg2)
    if collision then
      return {x = collision.x, y = collision.y}
      --return true
    end
  end
  return false
end

-- Collision polygone vs polygone.
function Polygon_Vs_Polygon(poly_1, poly_2, seg1, seg2)
  local suivant = 1
  for current=1,#poly_1 do
    suivant = current + 1
    if suivant == #poly_1+1 then
      suivant = 1
    end
    
    local v_current = poly_1[current]
    local v_suivant = poly_1[suivant]
    local collision = Line_Vs_Polygon(poly_2, v_current.x, v_current.y, v_suivant.x, v_suivant.y, seg1, seg2)
    if collision then
      --print(collision.x, collision.y)
      return {x = collision.x, y = collision.y}
      --return true
    end
    local inside = Point_Vs_Polygon(poly_1[1].x, poly_1[1].y, poly_2)
    if inside then
      return true
    end
  end
  return false
end

-- Résolution de collisions entre deux cercles.
function Resolve_Circle_Vs_Rect(dt, p_joueur, p_obstacle)
  local guessed_position = p_joueur.position + p_joueur.velocite*dt
  local current_position = p_joueur.position
  local target_position = guessed_position
  local nearest_point = Vector(0, 0)
  nearest_point.x = math.max(p_obstacle.position.x, math.min(guessed_position.x, p_obstacle.position.x+p_obstacle.size.x))
  nearest_point.y = math.max(p_obstacle.position.y, math.min(guessed_position.y, p_obstacle.position.y+p_obstacle.size.y))
  local ray_to_nearest = nearest_point - guessed_position
  local magnitude = ray_to_nearest.Get_Norme()
  local overlap = p_joueur.rayon-magnitude
  if type(overlap) ~= "number" then
    overlap = 0
  end
  if overlap > 0 then
    ray_to_nearest.normalize()
    guessed_position = guessed_position - ray_to_nearest*overlap
  end
  p_joueur.position = guessed_position
end

-- Inversion de la vélocité d'un sprite circulaire (p_joueur) s'il entre en collision
-- avec un sprite rectangulaire.
function Invert_Velocity(p_joueur, p_rect)
  if p_joueur.position.x > p_rect.position.x and p_joueur.position.x < p_rect.position.x+p_rect.size.x then
    p_joueur.velocite.y = -p_joueur.velocite.y
  else
    p_joueur.velocite.x = -p_joueur.velocite.x
  end
end

-- Construction des normales selon le opint de collision entre le vecteur de
-- vélocité du player et le rectangle "obstacle".
function Construct_Normal(player, target)
  local contact_normal = Vector(0, 0)
  local inv_dir = Vector(0, 0)
  inv_dir.x = 1/player.velocite.x
  inv_dir.y = 1/player.velocite.y
  
  local t_near = Vector(0, 0)
  t_near.x = (target.position.x-(player.position.x+player.size.x/2)) * inv_dir.x
  t_near.y = (target.position.y-(player.position.y+player.size.y/2)) * inv_dir.y
  
  local t_far = Vector(0, 0)
  t_far.x = ((target.position.x+target.size.x)-(player.position.x+player.size.x/2)) * inv_dir.x
  t_far.y = ((target.position.y+target.size.y)-(player.position.y+player.size.y/2)) * inv_dir.y
  
  if type(t_near.x) ~= "number" or type(t_near.y) ~= "number" then return false end
  if type(t_far.x) ~= "number" or type(t_far.y) ~= "number" then return false end
  
  if t_near.x > t_far.x then t_near.x, t_far.x = Swap(t_near.x, t_far.x) end
  if t_near.y > t_far.y then t_near.y, t_far.y = Swap(t_near.y, t_far.y) end
  
  if t_near.x > t_far.y or t_near.y > t_far.x then return false end
  
  local t_hit_near = math.max(t_near.x, t_near.y)
  local t_hit_far = math.min(t_far.x, t_far.y)
  
  if t_hit_far < 0 then return false end
  
  if t_near.x > t_near.y then
    if inv_dir.x < 0 then
      contact_normal = Vector(1, 0)
    else
      contact_normal = Vector(-1, 0)
    end
  elseif t_near.x < t_near.y then
    if inv_dir.y < 0 then
      contact_normal = Vector(0, 1)
    else
      contact_normal = Vector(0, -1)
    end
  end
  return contact_normal
end

-- Résolution de la collision entre deux rectangles.
function Resolve_Rect_Vs_Rect(player, obstacle)
  local ex = {}
  ex.pos = obstacle.position - player.size/2
  ex.size = obstacle.position + player.size
  local expanded_target = Create_Rect(ex.pos.x, ex.pos.y, ex.size.x, ex.size.y, false)
  
  local origin_x = player.position.x + player.size.x/2
  local origin_y = player.position.y + player.size.y/2
  local dir_x = player.position.x+player.size.x/2 + player.velocite.x
  local dir_y = player.position.y+player.size.y/2 + player.velocite.y
  
  local c = Line_Vs_Polygon(obstacle.verticies, origin_x, origin_y, dir_x, dir_y, false, false)
  if c then
    local contact_normal = Construct_Normal(player, expanded_target)
    b = Polygon_Vs_Polygon(player.verticies, obstacle.verticies, true, true)
    if b then
      local vel_length = player.velocite.Get_Norme()
      local overlap_length = Vector(c.x, c.y) - (player.position+player.size/2)
      local temps = overlap_length.Get_Norme()/vel_length
      if type(contact_normal) == "table" then
        if contact_normal.y > 0 then player.position.y = obstacle.position.y+obstacle.size.y end
        if contact_normal.x < 0 then player.position.x = obstacle.position.x-player.size.x end
        if contact_normal.y < 0 then player.position.y = obstacle.position.y-player.size.y end
        if contact_normal.x > 0 then player.position.x = obstacle.position.x+obstacle.size.x end
        
        player.velocite.x = player.velocite.x + contact_normal.x * math.abs(player.velocite.x) * (1-temps)
        player.velocite.y = player.velocite.y + contact_normal.y * math.abs(player.velocite.y) * (1-temps)
      end
    end
  end
end

-- Théorème des axes séparés, version qui ne fait que détecter l'overlap.
function Sat_Overlap(p1, p2)
  local poly_1 = p1
  local poly_2 = p2
  
  for shape=1,2 do
    if shape == 2 then
      poly_1, poly_2 = Swap(poly_1, poly_2)
    end
    
    for a=1,#poly_1.verticies do
      local b = a+1
      if b > #poly_1.verticies then
        b = 1
      end
      local projected_axis = Vector(-(poly_1.verticies[b].y-poly_1.verticies[a].y), poly_1.verticies[b].x-poly_1.verticies[a].x)
      local d = math.sqrt(projected_axis.x*projected_axis.x + projected_axis.y*projected_axis.y)
      projected_axis = projected_axis / d
      
      local min_p1 = math.huge
      local max_p1 = -math.huge
      for p=1,#poly_1.verticies do
        local q = poly_1.verticies[p].x*projected_axis.x + poly_1.verticies[p].y*projected_axis.y
        min_p1 = math.min(min_p1, q)
        max_p1 = math.max(max_p1, q)
      end
      
      local min_p2 = math.huge
      local max_p2 = -math.huge
      for p=1,#poly_2.verticies do
        local q = poly_2.verticies[p].x*projected_axis.x + poly_2.verticies[p].y*projected_axis.y
        min_p2 = math.min(min_p2, q)
        max_p2 = math.max(max_p2, q)
      end
      
      if not (max_p2>=min_p1) and (max_p1>=min_p2) then
        return false
      end
    end
    
  end
  return true
end

-- Théorème des axes séparés, version avec résolution de la collision.
function Sat_Resolution(p1, p2)
  local poly_1 = p1
  local poly_2 = p2
  local overlap = math.huge
  
  for shape=1,2 do
    if shape == 2 then
      poly_1, poly_2 = Swap(poly_1, poly_2)
    end
    
    for a=1,#poly_1.verticies do
      local b = a+1
      if b > #poly_1.verticies then
        b = 1
      end
      local projected_axis = Vector(-(poly_1.verticies[b].y-poly_1.verticies[a].y), poly_1.verticies[b].x-poly_1.verticies[a].x)
      local d = math.sqrt(projected_axis.x*projected_axis.x + projected_axis.y*projected_axis.y)
      projected_axis = projected_axis / d
      
      local min_p1 = math.huge
      local max_p1 = -math.huge
      for p=1,#poly_1.verticies do
        local q = poly_1.verticies[p].x*projected_axis.x + poly_1.verticies[p].y*projected_axis.y
        min_p1 = math.min(min_p1, q)
        max_p1 = math.max(max_p1, q)
      end
      
      local min_p2 = math.huge
      local max_p2 = -math.huge
      for p=1,#poly_2.verticies do
        local q = poly_2.verticies[p].x*projected_axis.x + poly_2.verticies[p].y*projected_axis.y
        min_p2 = math.min(min_p2, q)
        max_p2 = math.max(max_p2, q)
      end
      
      overlap = math.min(math.min(max_p1, max_p2)-math.max(min_p1, min_p2), overlap)
      if not (max_p2>=min_p1) and (max_p1>=min_p2) then
        return false
      end
    end
    
  end
  local dist = Vector(p2.position.x-p1.position.x, p2.position.y-p1.position.y)
  local s = math.sqrt(dist.x*dist.x + dist.y*dist.y)
  if overlap ~= math.huge and overlap ~= -math.huge then
    p1.position.x = p1.position.x - ((overlap*dist.x) / s)
    p1.position.y = p1.position.y - ((overlap*dist.y) / s)
  end
  return false
end

-- Détection de collisions en comparant les diagonales d'un polygone avec
-- les côtés d'un autre polygone.
function Diags_Overlap(p1, p2)
  local poly_1 = p1
  local poly_2 = p2
  
  for shape=1,2 do
    if shape == 2 then
      poly_1, poly_2 = Swap(poly_1, poly_2)
    end
    
    for p=1,#poly_1.verticies do
      local diag_p1_start = poly_1.position
      local diag_p1_end = poly_1.verticies[p]
      
      for q=1,#poly_2.verticies do
        local side_p2_start = poly_2.verticies[q]
        local side_p2_end =  0 
        if q+1 > #poly_2.verticies then
          side_p2_end = poly_2.verticies[1]
        else
          side_p2_end = poly_2.verticies[q+1]
        end
        local h = (side_p2_end.x-side_p2_start.x)*(diag_p1_start.y-diag_p1_end.y) - (diag_p1_start.x-diag_p1_end.x)*(side_p2_end.y-side_p2_start.y)
        local t1 = ( (side_p2_start.y-side_p2_end.y)*(diag_p1_start.x-side_p2_start.x) + (side_p2_end.x-side_p2_start.x)*(diag_p1_start.y-side_p2_start.y) ) / h
        local t2 = ( (diag_p1_start.y-diag_p1_end.y)*(diag_p1_start.x-side_p2_start.x) + (diag_p1_end.x-diag_p1_start.x)*(diag_p1_start.y-side_p2_start.y) ) / h
        
        if (t1 >= 0 and t1 <1 and t2 >= 0 and t2 < 1) then
          return true
        end
        
      end
      
    end
    
  end
  return false
end

-- Résolution de collisions en utilisant la méthode des diagonales
function Diags_Resolution(p1, p2)
  local poly_1 = p1
  local poly_2 = p2
  
  for shape=1,2 do
    if shape == 2 then
      poly_1, poly_2 = Swap(poly_1, poly_2)
    end
    
    for p=1,#poly_1.verticies do
      local diag_p1_start = poly_1.position
      local diag_p1_end = poly_1.verticies[p]
      local displacement = Vector(0, 0)
      
      for q=1,#poly_2.verticies do
        local side_p2_start = poly_2.verticies[q]
        local side_p2_end =  0 
        if q+1 > #poly_2.verticies then
          side_p2_end = poly_2.verticies[1]
        else
          side_p2_end = poly_2.verticies[q+1]
        end
        local h = (side_p2_end.x-side_p2_start.x)*(diag_p1_start.y-diag_p1_end.y) - (diag_p1_start.x-diag_p1_end.x)*(side_p2_end.y-side_p2_start.y)
        local t1 = ( (side_p2_start.y-side_p2_end.y)*(diag_p1_start.x-side_p2_start.x) + (side_p2_end.x-side_p2_start.x)*(diag_p1_start.y-side_p2_start.y) ) / h
        local t2 = ( (diag_p1_start.y-diag_p1_end.y)*(diag_p1_start.x-side_p2_start.x) + (diag_p1_end.x-diag_p1_start.x)*(diag_p1_start.y-side_p2_start.y) ) / h
        
        if (t1 >= 0 and t1 <1 and t2 >= 0 and t2 < 1) then
          displacement.x = displacement.x + (1-t1) * (diag_p1_end.x-diag_p1_start.x)
          displacement.y = displacement.y + (1-t1) * (diag_p1_end.y-diag_p1_start.y)
        end
        
      end
      if shape == 1 then
        p1.position.x = p1.position.x + displacement.x*(-1)
        p1.position.y = p1.position.y + displacement.y*(-1)
      else
        p1.position.x = p1.position.x + displacement.x*1
        p1.position.y = p1.position.y + displacement.y*1
      end
    end
    
  end
  return false
end

---------------------------------------------------------

-- Fonction qui permet d'empêcher un cercle de sortir d'un rectangle.
function Clamp_Circle_Inside_Rect(k1, k2, pRond, pRect)
  pRond.x = Clamp(k1, pRect.x+pRond.r, pRect.x+pRect.w-pRond.r)
  pRond.y = Clamp(k2, pRect.y+pRond.r, pRect.y+pRect.h-pRond.r)
end


--------------------------------------------------------------------

-- Permet de vérifier si le clic gauche souris se trouve sur un point donné.
function Get_Clicked_Point(px, py, ptable)
  for i=1,#ptable do
    local r = ptable[i]
    local dx = r.x - px
    local dy = r.y - py
    local dist = math.sqrt(dx*dx + dy*dy)
    if dist < 10 then
      return r
    end
  end
end

-- Vérifie si deux lignes se coupent.
function Line_Intersect(p0, p1, p2, p3, segment_A, segment_B)
  local A1 = p1.y - p0.y
  local B1 = p0.x - p1.x
  local C1 = A1*p0.x + B1*p0.y
  
  local A2 = p3.y - p2.y
  local B2 = p2.x - p3.x
  local C2 = A2*p2.x + B2*p2.y
  
  local denominateur = A1*B2 - A2*B1
  if denominateur == 0 then
    return false
  end
  
  local intersect_x = (B2*C1 - B1*C2) / denominateur
  local intersect_y = (A1*C2 - A2*C1) / denominateur
  
  local rx_0 = (intersect_x - p0.x) / (p1.x - p0.x)
  local ry_0 = (intersect_y - p0.y) / (p1.y - p0.y)
  local rx_1 = (intersect_x - p2.x) / (p3.x - p2.x)
  local ry_1 = (intersect_y - p2.y) / (p3.y - p2.y)
  if segment_A and not ((rx_0 >= 0 and rx_0 <= 1) or (ry_0 >= 0 and ry_0 <= 1)) then
    return false
  end
  if segment_B and not ((rx_1 >= 0 and rx_1 <= 1) or (ry_1 >= 0 and ry_1 <= 1)) then
    return false
  end
  
  return {x = intersect_x, y = intersect_y}
end


-- Fonction qui permet de vérifier si deux polygones sont en collision
function Check_Star_Collision(star_a, star_b)
  for i=1,#star_a do
    local p0 = star_a[i]
    local p1 = star_a[i+1]
    if  i == #star_a then
      p0 = star_a[i]
      p1 = star_a[1]
    end
    
    for j=1,#star_b do
      local p2 = star_b[j]
      local p3 = star_b[j+1]
      if j == #star_b then
        p2 = star_b[j]
        p3 = star_b[1]
      end
      
      if Line_Intersect(p0, p1, p2, p3, true, true) then
        return true
      end
    end
  end
  return false
end

io.stdout:setvbuf('no')
if arg[arg] == "-debug" then require("mobdebug").start() end
love.graphics.setDefaultFilter("nearest")

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function math.normalize(x,y) local l=(x*x+y*y)^.5 if l==0 then return 0,0,0 else return x/l,y/l,l end end

--function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end
function math.dist(x1,y1, x2,y2) return math.sqrt((x2-x1)^2 + (y2-y1)^2) end

function Circle_Vs_Rect(circle_x, circle_y, rayon, rect_x, rect_y, rect_w, rect_h)
  text_x = circle_x
  text_y = circle_y
  
  if circle_x < rect_x then
    text_x = rect.x
  elseif circle_x > rect_x+rect_w then
    text_x = rect_x+rect_w
  end
  
  if circle_y < rect_y then
    text_y = rect_y
  elseif circle_y > rect_y+rect_h then
    text_y = rect_y+rect_h
  end
  
  dist_x = circle_x - text_x
  dist_y = circle_y - text_y
  distance = math.sqrt((dist_x^2)+(dist_y^2))
  
  if distance <= rayon then
    return true
  else
    return false
  end
end

function Move_Player(up, right, down, left, player, dt)
  player.vx = 0
  player.vy = 0
  local speed = 25
  
  if love.keyboard.isDown(up) then
    player.vy = -speed * dt
  end
  if love.keyboard.isDown(right) then
    player.vx = speed * dt
  end
  if love.keyboard.isDown(down) then
    player.vy = speed * dt
  end
  if love.keyboard.isDown(left) then
    player.vx = -speed * dt
  end
  player.vx, player.vy = math.normalize(player.vx, player.vy)
  
  player.x = player.x + player.vx
  player.y = player.y + player.vy
end

function love.load()
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  
  rect = {}
  rect.w = 150
  rect.h = 100
  rect.x = largeur/2 - rect.w/2
  rect.y = hauteur/2 - rect.h/2
  
  rect_bb = {}
  rect_bb.w = 250
  rect_bb.h = 200
  rect_bb.x = rect.x-50
  rect_bb.y = rect.y-50
  
  circle = {}
  circle.r = 25
  circle.x = 100
  circle.y = 100
  circle.vx = 0
  circle.vy = 0
  
  circle_bb = {}
  circle_bb.w = circle.r*4
  circle_bb.h = circle.r*4
  circle_bb.x = circle.x-(circle.r*2)
  circle_bb.y = circle.y-(circle.r*2)
  
  v_guessed_position = {x=0, y=0}
  v_current_position = {x=0, y=0}
  v_target_position = {x=0, y=0}
  v_nearest_point = {x=0, y=0}
  v_ray_to_nearest = {x=0, y=0}
  overlap = 0
end

function love.update(dt)
  Move_Player("up", "right", "down", "left", circle, dt)
  
  circle_bb.x = circle.x-(circle.r*2)
  circle_bb.y = circle.y-(circle.r*2)
  
  v_guessed_position = {x=circle.x+circle.vx*dt, y=circle.y+circle.vy*dt}
  v_current_position = {x=math.floor(circle.x), y=math.floor(circle.y)}
  v_target_position = {x=v_guessed_position.x, y=v_guessed_position.y}
  
  boum_bb = CheckCollision(circle_bb.x, circle_bb.y, circle_bb.w, circle_bb.h, rect_bb.x, rect_bb.y, rect_bb.w, rect_bb.h)
  boum = Circle_Vs_Rect(circle.x, circle.y, circle.r, rect.x, rect.y, rect.w, rect.h)
  if boum then
    v_nearest_point = {x=math.max(rect.x, math.min(v_guessed_position.x, rect.x+rect.w)), y=math.max(rect.y, math.min(v_guessed_position.y, rect.y+rect.h))}
    v_ray_to_nearest = {x=v_nearest_point.x-v_guessed_position.x, y=v_nearest_point.y-v_guessed_position.y}
    magnitude = math.dist(0, 0, v_ray_to_nearest.x, v_ray_to_nearest.y)
    overlap = circle.r - magnitude
    if type(overlap) ~= "number" then
      overlap = 0
    end
    if overlap > 0 then
      norm_ray_x, norm_ray_y = math.normalize(v_ray_to_nearest.x, v_ray_to_nearest.y)
      v_guessed_position = {x=v_guessed_position.x-(norm_ray_x*overlap), y=v_guessed_position.y-(norm_ray_y*overlap)}
    end
    circle.x = v_guessed_position.x
    circle.y = v_guessed_position.y
  end
end

function love.draw()
  if boum_bb then
    love.graphics.setColor(0, 1, 1)
  else
    love.graphics.setColor(0, 1, 0)
  end
  love.graphics.rectangle("line", rect_bb.x, rect_bb.y, rect_bb.w, rect_bb.h)
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("line", circle_bb.x, circle_bb.y, circle_bb.w, circle_bb.h)
  if boum then
    love.graphics.setColor(1, 0, 0)
  else
    love.graphics.setColor(1, 0, 1)
  end
  love.graphics.rectangle("fill", rect.x, rect.y, rect.w, rect.h)
  love.graphics.setColor(1, 1, 0)
  love.graphics.circle("fill", circle.x, circle.y, circle.r)
  love.graphics.setColor(1, 1, 1)
  
  love.graphics.print("boum: "..tostring(boum), 5, 5)
  love.graphics.print("circle.x: "..tostring(circle.x), 5, 5+16)
  love.graphics.print("circle.y: "..tostring(circle.y), 5, 5+16*2)
  love.graphics.print("v_guessed_position.x: "..tostring(v_guessed_position.x), 5, 5+16*3)
  love.graphics.print("v_guessed_position.y: "..tostring(v_guessed_position.y), 5, 5+16*4)
  love.graphics.print("v_current_position.x: "..tostring(v_current_position.x), 5, 5+16*5)
  love.graphics.print("v_current_position.y: "..tostring(v_current_position.y), 5, 5+16*6)
  love.graphics.print("v_nearest_point.x: "..tostring(v_nearest_point.x), 5, 5+16*7)
  love.graphics.print("v_nearest_point.y: "..tostring(v_nearest_point.y), 5, 5+16*8)
  love.graphics.print("v_ray_to_nearest.x: "..tostring(v_ray_to_nearest.x), 5, 5+16*9)
  love.graphics.print("v_ray_to_nearest.y: "..tostring(v_ray_to_nearest.y), 5, 5+16*10)
  love.graphics.print("magnitude: "..tostring(magnitude), 5, 5+16*11)
  love.graphics.print("overlap: "..tostring(overlap), 5, 5+16*12)
end

function Line_Intersect(p0, p1, p2, p3, segment_A, segment_B)
  local A1 = p1.y - p0.y
  local B1 = p0.x - p1.x
  local C1 = A1*p0.x + B1*p0.y
  
  local A2 = p3.y - p2.y
  local B2 = p2.x - p3.x
  local C2 = A2*p2.x + B2*p2.y
  
  local denominateur = A1*B2 - A2*B1
  if denominateur == 0 then
    return false
  end
  
  local intersect_x = (B2*C1 - B1*C2) / denominateur
  local intersect_y = (A1*C2 - A2*C1) / denominateur
  
  local rx_0 = (intersect_x - p0.x) / (p1.x - p0.x)
  local ry_0 = (intersect_y - p0.y) / (p1.y - p0.y)
  local rx_1 = (intersect_x - p2.x) / (p3.x - p2.x)
  local ry_1 = (intersect_y - p2.y) / (p3.y - p2.y)
  if segment_A and not ((rx_0 >= 0 and rx_0 <= 1) or (ry_0 >= 0 and ry_0 <= 1)) then
    return false
  end
  if segment_B and not ((rx_1 >= 0 and rx_1 <= 1) or (ry_1 >= 0 and ry_1 <= 1)) then
    return false
  end
  
  return {x = intersect_x, y = intersect_y}
end