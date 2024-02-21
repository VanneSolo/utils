-- Déplace un point sur une distance.
function Move_Point_From_A_To_B(x1, y1, x2, y2)
  local p1 = Point(x1, y1)
  local p2 = Point(x2, y2)
  local pA = {p1.x, p1.y}
  local t = 0
  local ghost = {}
  ghost.Update = function(dt)
    t = t + 0.02
    t = math.min(t, 1)
    pA.x = Lerp(t, p1.x, p2.x)
    pA.y = Lerp(t, p1.y, p2.y)
  end
  ghost.Draw = function()
    love.graphics.circle("fill", p1.x, p1.y, 4)
    love.graphics.circle("fill", p2.x, p2.y, 4)
    love.graphics.circle("fill", pA.x, pA.y, 4)
    love.graphics.line(p1.x, p1.y, pA.x, pA.y)
  end
  return ghost
end

-- Fait se mouvoir un segement par interpolation linéaire
-- avec deux autres segments.
function Lerp_Line(x1, y1, x2, y2, x3, y3)
  local p1 = Point(x1, y1)
  local p2 = Point(x2, y2)
  local p3 = Point(x3, y3)
  local pA = {p1.x, p1.y}
  local pB = {p2.x, p2.y}
  local t = 0
  local ghost = {}
  ghost.Update = function(dt)
    t = t + 0.01
    t = math.min(t, 1)
    pA.x = Lerp(t, p1.x, p2.x)
    pA.y = Lerp(t, p1.y, p2.y)
    pB.x = Lerp(t, p2.x, p3.x)
    pB.y = Lerp(t, p2.y, p3.y)
  end
  ghost.Draw = function()
    love.graphics.circle("fill", p1.x, p1.y, 4)
    love.graphics.circle("fill", p2.x, p2.y, 4)
    love.graphics.circle("fill", p3.x, p3.y, 4)
    love.graphics.circle("fill", pA.x, pA.y, 4)
    love.graphics.circle("fill", pB.x, pB.y, 4)
    love.graphics.line(p1.x, p1.y, p2.x, p2.y)
    love.graphics.line(p2.x, p2.y, p3.x, p3.y)
    love.graphics.line(pA.x, pA.y, pB.x, pB.y)
    
    Indique_Point(p1, "p1", 0, 25)
    Indique_Point(p2, "p2", 0, -25)
    Indique_Point(p3, "p3", -50, 25)
    Indique_Point(pA, "pA", 0, 25)
    Indique_Point(pB, "pB", -50, -25)
    Affiche_Variable("time", t, 5, 5)
  end
  return ghost
end

---------------------------------

-- Fait se déplacer un point vers les coordonnées d'un clic de souris
-- avec un effet de ralentissement vers l'arrivée.
function Point_To_Target(tx, ty, pos_x, pos_y, p_ease)
  local target = Point(tx, ty)
  local position = Point(pos_x, pos_y)
  local ease = p_ease
  local ghost = {}
  ghost.Update = function(dt)
    local dx, dy = target.x - position.x, target.y - position.y
    local vx, vy = dx * ease, dy * ease
    
    position.x = position.x + vx
    position.y = position.y + vy
  end
  ghost.Draw = function()
    Draw_Points(position, 10)
  end
  ghost.Mouse_Pressed = function(x, y, button)
    mouse_x, mouse_y = love.mouse.getPosition()
    if button == 1 then
      target.x = mouse_x
      target.y = mouse_y
    end
  end
  return ghost
end

---------------------------------------------------------

-- Déplace un point vers le curseur de la souris.
function Point_To_Target_2(pos_x, pos_y, tar_x, tar_y, p_ease)
  local target = {}
  target.x = tar_x
  target.y = tar_y
  local position = {}
  position.x = pos_x
  position.y = pos_y
  local ease = p_ease
  local easing = true
  local ghost = {}
  ghost.Update = function(dt)
    easing = Ease_To(position, target, ease)
  end
  ghost.Draw = function()
    Draw_Points(position, 10)
    love.graphics.print("easing: "..tostring(easing), 5, 5)
  end
  ghost.Mouse_Pressed = function(x, y, button)
    target.x = x
    target.y = y
    if easing == false then
      easing = true
    end
  end
  return ghost
end

------------------------------------------------------------------------------

	-- Décollage d'une fusée

io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[arg] == "-debug" then require("mobdebug").start() end

function love.load()
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  
  timer_depart = 40
  depart_compte_a_rebours = false
  
  etapes = {}
  etapes[1] = "Evacuez la tour de lancement!"
  etapes[2] = "Préparation du pas de tir."
  etapes[3] = "Retirez les bras cryogéniques."
  etapes[4] = "Allumage des moteurs."
  etapes[5] = "Décollage!"
  
  etape_courante = 1
  
  fusee = {}
  fusee.x = 380
  fusee.y = 520
  fusee.vy = 5
  fusee.width = 40
  fusee.height = 80
end

function love.update(dt)
  if depart_compte_a_rebours == true then
    timer_depart = timer_depart - dt
    if timer_depart <= 0 then
      timer_depart = 0
    end
    
    if timer_depart <= 0 and etape_courante ~= 5 then
    etape_courante = 5
    elseif timer_depart <= 10 and timer_depart > 0 and etape_courante ~= 4 then
      etape_courante = 4
    elseif timer_depart <= 20 and timer_depart > 10 and etape_courante ~= 3 then
      etape_courante = 3
    elseif timer_depart <= 30 and timer_depart > 20 and etape_courante ~= 2 then
      etape_courante = 2
    end
    
    if etape_courante == 5 then
      fusee.y = fusee.y - fusee.vy
    end
    
  end
  
end

function love.draw()
  love.graphics.print("Compte à rebours: "..tostring(math.floor(timer_depart)), 1, 1)
  
  if depart_compte_a_rebours == true then
    love.graphics.print("Etat du lancement: "..tostring(etapes[etape_courante]), 1, 16)
  end
  
  love.graphics.rectangle("fill", fusee.x, fusee.y, fusee.width, fusee.height)
end

function love.keypressed(key)
  if key == "space" then
    depart_compte_a_rebours = true
  end
end