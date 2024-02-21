--[[

    Concentration ici de tout ce qui a trait aux systèmes de particules.

]]

    -- Système de particules qui génère une explosion lors d'un clic souris.
    
io.stdout:setvbuf('no')
if arg[arg] == "-debug" then require("mobdebug").start() end

function love.load()
  liste_particule = {}
  
  --Ajoute_Explosion(400, 300)
  --Ajoute_Explosion(100, 100)
end

function love.update(dt)
  for i=#liste_particule, 1, -1 do
    local particule = liste_particule[i]
    particule.x = particule.x + particule.vx
    particule.y = particule.y + particule.vy
    particule.vie = particule.vie - dt
    if particule.vie <= 0 then
      table.remove(liste_particule, i)
    end
  end
end

function love.draw()
  for i=1,#liste_particule do
    local particule = liste_particule[i]
    if particule.vie >= 0.1 then
      love.graphics.setColor(1, 1, 1)
    else
      love.graphics.setColor(1, 0, 0)
    end
    love.graphics.rectangle("fill", particule.x, particule.y, 5, 5)
  end
end

function Ajoute_Particule(pX, pY)
  particule = {}
  particule.x = pX
  particule.y = pY
  particule.vx = love.math.random(-300, 300)/100
  particule.vy = love.math.random(-300, 300)/100
  particule.vie = love.math.random(50, 300)/100
  table.insert(liste_particule, particule)
end

function Ajoute_Explosion(pX, pY)
  for i=1,50 do
    Ajoute_Particule(pX, pY)
  end
end

function love.mousepressed(x, y, button)
  if button == 1 then
    Ajoute_Explosion(x, y)
  end
end

--[[_______________________________________________________________________________________________
___________________________________________________________________________________________________
]]

    -- Effet de trainée
    
io.stdout:setvbuf('no')
if arg[arg] == "-debug" then require("mobdebug").start() end

function love.load()
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  
  joueur = {}
  joueur.x = largeur/2
  joueur.y = hauteur/2
  joueur.r = 5
  joueur.v = 2
  
  liste_traine = {}
end

function love.update(dt)
  for i=#liste_traine,1,-1 do
    local queue = liste_traine[i]
    queue.vie = queue.vie - dt
    queue.x = queue.x + queue.vx
    queue.y = queue.y + queue.vy
    if queue.vie <= 0 then
      table.remove(liste_traine, i)
    end
  end
  
  local part_traine = {}
  part_traine.x = joueur.x
  part_traine.y = joueur.y
  part_traine.vx = love.math.random(-1, 1)
  part_traine.vy = love.math.random(-1, 1)
  part_traine.vie = 0.5
  table.insert(liste_traine, part_traine)
  
  if love.keyboard.isDown("up") then
    joueur.y = joueur.y - joueur.v
  end
  if love.keyboard.isDown("right") then
    joueur.x = joueur.x + joueur.v
  end
  if love.keyboard.isDown("down") then
    joueur.y = joueur.y + joueur.v
  end
  if love.keyboard.isDown("left") then
    joueur.x = joueur.x - joueur.v
  end
end

function love.draw()
  for i=1,#liste_traine do
    local queue = liste_traine[i]
    love.graphics.setColor(1, 1, 1, queue.vie/2)
    love.graphics.circle("fill", queue.x, queue.y, joueur.r)
  end
  
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.circle("fill", joueur.x, joueur.y, joueur.r)
end


--------------------------------------------------------------------------------------------

require("vector")

function Particule(pX, pY, pWidth, pHeight, pRadius, pSprite, pAngle, pOx, pOy, pSpeed, pDirection, pGravity)
  -- Table particule qui continent toutes les données et les fonctions
  -- potentiellemnt nécessaire à la génération et au fonctionnement d'une
  -- particule.
  local particule = {}
  particule.position = Vector(pX, pY)
  particule.size = Vector(pWidth, pHeight)
  particule.rayon = pRadius
  particule.img = pSprite
  particule.rotation = pAngle
  particule.origine = Vector(pOx, pOy)
  particule.velocite = Vector(0, 0)
  particule.velocite.Set_Norme(pSpeed)
  particule.velocite.Set_Angle(pDirection)
  particule.gravity = Vector(0, pGravity)
  particule.masse = 1
  particule.friction = 0.98
  particule.springs = {}
  particule.gravitations  = {}
  
  -- Ajoute de la gravité à une particule.
  particule.Add_Gravitation = function(p)
    particule.Remove_Gravitation(p)
    table.insert(particule.gravitations, p)
  end
  
  -- Retire la gravité d'une particule.
  particule.Remove_Gravitation = function(p)
    for i=1,#particule.gravitations do
      if p == particule.gravitations[i] then
        table.remove(particule.gravitations, i)
        return
      end
    end
  end
  
  -- Ajoute une force élastique à une particule.
  particule.Add_Spring = function(p_point, p_k, p_length)
    particule.Remove_Spring(p_point)
    table.insert(particule.springs, {point=p_point, k=p_k, length=p_length})
  end
  
  -- Retire la force élastique d'une particule.
  particule.Remove_Spring = function(p_point)
    for i=1,#particule.springs do
      if p_point == particule.springs[i] then
        table.remove(particule.springs, i)
        return
      end
    end
  end
  
  -- Ajoute un point d'ancrage à une particule.
  particule.Spring_To = function(p_point, p_k, p_length)
    local d = p_point - particule.position
    dist = math.sqrt(d.x^2 + d.y^2)
    spring_force = (dist - p_length) * p_k
    particule.velocite.x = particule.velocite.x + d.x/dist*spring_force
    particule.velocite.y = particule.velocite.y + d.y/dist*spring_force
  end
  
  -- Gère les élastiques d'une particule en particulier.
  particule.Handle_Springs = function()
    for i=1,#particule.springs do
      local spring = particule.springs[i]
      particule.Spring_To(spring.point, spring.k, spring.length)
    end
  end
  
  -- Gère les attractoions que subie une particule.
  particule.Handle_Gravitations = function()
    for i=1,#particule.gravitations do
      particule.Gravite_Vers(particule.gravitations[i])
    end
  end
  
  -- Récupère la vitesse d'une particule.
  particule.Get_Speed = function()
    return math.sqrt(particule.velocite.x^2 + particule.velocite.y^2)
  end
  
  -- Défini la vitesse d'une particule.
  particule.Set_Speed = function(p_speed)
    local heading = particule.Get_Heading()
    particule.velocite.x = math.cos(heading) * p_speed
    particule.velocite.y = math.sin(heading) * p_speed
  end
  
  -- Récupère la direction (l'angle) d'une particule.
  particule.Get_Heading = function()
    return math.atan2(particule.velocite.y, particule.velocite.x)
  end
  
  -- Défini la direction (l'angle) d'une particule.
  particule.Set_Heading = function(p_heading)
    local speed = particule.Get_Speed()
    particule.velocite.x = math.cos(p_heading) * speed
    particule.velocite.y = math.sin(p_heading) * speed
  end
  
  -- La fonction Accelerate prend un parametre qui est ajouté à la vélocité
  -- de l'entité à déplacer. A chaque frame la nouvelle valeur de la vélocité
  -- est de nouveau augmentée de la valeur du paramètre accel.
  particule.Accelerate = function(accel)
    particule.velocite.Add_To(accel)
  end
  -- La fonction Update permet de mettre à jour la position de la particule.
  -- On multiplie la vélocité par la friction. On ajoute à la onuvelle vélocité
  -- la gravité puis on jaoute la vélocité à la position.
  particule.Update = function(dt)
    particule.Handle_Springs()
    particule.Handle_Gravitations()
    particule.velocite.Multiply_By(particule.friction)
    particule.velocite.Add_To(particule.gravity)
    particule.position.Add_To(particule.velocite)
  end
  -- La fonction Angle_Vers permet de récupérer l'angle formé par un segment
  -- passant par deux points et l'horizontale. Pour cela on calcule l'opposé
  -- de la tangeante dans un trizngle rectangle formé par la position des deux
  -- particules et un tropisième ppint crée par la soustraction des valeurs y
  -- des deux premiers point d'une part et la soustraction des valeurs x de 
  -- ces mêmes points d'autre part.
  particule.Angle_Vers = function(particule_2)
    return math.atan2(particule_2.position.Get_Y()-particule.position.Get_Y(), particule.position.Get_X()-particule.position.Get_X())
  end
  -- La fonction Distance_Vers récupère la distance entre deux points.
  particule.Distance_Vers = function(particule_2)
    local dx = particule_2.position.Get_X() - particule.position.Get_X()
    local dy = particule_2.position.Get_Y() - particule.position.Get_Y()
    return math.sqrt(dx*dx + dy*dy)
  end
  -- La fonction Gravite_Autour permet de faire tourner une particule autour d'une autre. On
  -- crée un vecteur de gravité et puis une variable numérique dans laquelle on récupère la 
  -- distance entre les deux particules concernées. Ensuite on donne au vecteur de gravité sa
  -- longueur: masse de la particule autour de laquelle la première particule va tourner
  -- divisée par la distance entre les deux particules au carré. Pour finir on ajoute le vecteur
  -- de gravité à la vélocité.
  particule.Gravite_Autour = function(particule_2)
    local grav = Vector(0, 0)
    local dist = particule.Distance_Vers(particule_2)
    grav.Set_Norme(particule_2.masse/(dist*dist))
    grav.Set_Angle(particule.Angle_Vers(particule_2))
    particule.velocite.Add_To(grav)
  end
  
  -- Autre fonction de gestion de la gravité entre deux particules.
  particule.Gravite_Vers = function(particule_2)
    local d = particule_2.position - particule.position
    local dist_sq = d.x^2 + d.y^2
    local dist = math.sqrt(dist_sq)
    local force = particule_2.masse / dist_sq
    local a = d / dist*force
    
    particule.velocite = particule.velocite + a
  end
  
  -- Fonction d'afffichage des particules. Pour l'instant seuls les cercles et les rectangles
  -- sont disponibles.
  particule.Draw = function(red, green, blue, pAlpha, pType)
    love.graphics.setColor(red, green, blue, pAlpha)
    if pType == "rect" then
      love.graphics.rectangle("fill", particule.position.x, particule.position.y, particule.size.x, particule.size.y)
    elseif pType == "circle" then
      love.graphics.circle("fill", particule.position.x, particule.position.y, particule.rayon)
    elseif pType == "image" then
      love.graphics.draw(particule.img, particule.position.x, particule.position.y, particule.rotation, 1, 1, particule.origine.x, particule.origine.y)
    end
    love.graphics.setColor(1, 1, 1, 1)
  end
  
  return particule
end

-- Fonction qui supprime les particules d'une liste.
function Remove_Dead_Particule(pElement)
  for i=#pElement,1,-1 do
    local p = pElement[i]
    if p.position.x - p.r >= largeur or
       p.position.x + p.r <= 0 or
       p.position.y - p.r >= hauteur or
       p.position.y + p.r <= 0 then
         table.remove(pElement,i)
    end
  end
end

-------------------------------------------------------------------------------------------

-- Dessine un point qui devient de plus en plus gros et opaque au fil du temps et qui respawn
-- quand il temps atteint une certaine valeur.
function Point_Grossissant(pMin_X, pMin_Y, pMax_X, pMax_Y, pMin_Radius, pMax_Radius, pMax_Time)
  local settings = {}
  settings.x = pMin_X
  settings.y = pMin_Y
  settings.r = pMin_Radius
  settings.g_alppha = 0
  settings.min_alppha = 0
  settings.max_alppha = 1
  settings.t = 0
  local p = {}
  p.Update = function(dt)
    settings.g_alpha = Lerp(settings.t, settings.min_alpha, settings.max_alpha)
    settings.x = Lerp(settings.t, pMin_X, pMax_X)
    settings.y = Lerp(settings.t, pMin_Y, pMax_Y)
    settings.r = Lerp(settings.t, pMin_Radius, pMax_Radius)
    settings.t = settings.t+0.01
    if settings.t >= pMax_Time then
      settings.t = 0
    end
  end
  p.Draw = function()
    love.graphics.setColor(1, 1, 1, settings.g_alpha)
    love.graphics.circle("fill", settings.x, settings.y, settings.r)
    love.graphics.setColor(1, 1, 1, 1)
  end
end

--------------------------------------------------------------------------------------

-- Applique un mouvement de va-et-vient.
function Va_Et_Vient(dt, pEntity)
  pHor = false
  pVert = false
  if pEntity.velocite.x ~= 0 then
    pHor = true
  else
    pHor = false
  end
  if pEntity.velocite.y ~= 0 then
    pVert = true
  else
    pVert = false
  end
  if pHor then
    if pEntity.position.x >= 600 then
      pEntity.position.x = 600
      pEntity.velocite.x = -pEntity.velocite.x
    end
    if pEntity.position.x <= 200 then
      pEntity.position.x = 200
      pEntity.velocite.x = -pEntity.velocite.x
    end
  end
  if pVert then
    if pEntity.position.y >= 400 then
      pEntity.position.y = 400
      pEntity.velocite.y = -pEntity.velocite.y
    end
    if pEntity.position.y <= 200 then
      pEntity.position.y = 200
      pEntity.velocite.y = -pEntity.velocite.y
    end
  end
end

-- Applique un mouvemnt de va et vient géré par une fonction sinus.
function Va_Et_Vient_Sinus(pEntity, depart, max, start_time)
  pHor = false
  pVert = false
  if pEntity.velocite.x ~= 0 then
    pHor = true
    end_time = max/joueur.velocite.x * 4
  else
    pHor = false
  end
  if pEntity.velocite.y ~= 0 then
    pVert = true
    end_time = max/joueur.velocite.y * 4
  else
    pVert = false
  end
  pulsation = math.pi*2 / end_time
  
  local unnamed = {}
  unnamed.Update = function(dt)
    start_time = start_time + dt
    if pHor then
      pEntity.position.x = depart + max * math.sin(pulsation*start_time)
      if start_time > end_time then
        start_time = 0
      end
    end
    if pVert then
      pEntity.position.y = depart + max * math.sin(pulsation*start_time)
      if start_time > end_time then
        start_time = 0
      end
    end
  end
  return unnamed
end

---------------------------------------------------------------------------------------------------------

-- Fait rebondir un cercle contre les bords de l'écran.
function Bounce_Circle(p_entity, rebunding)
  if p_entity.position.x + p_entity.rayon >= largeur then
    p_entity.position.Set_X(largeur-p_entity.rayon)
    p_entity.velocite.Set_X(p_entity.velocite.Get_X()*rebunding)
  elseif p_entity.position.x - p_entity.rayon <= 0 then
    p_entity.position.Set_X(p_entity.rayon)
    p_entity.velocite.Set_X(p_entity.velocite.Get_X()*rebunding)
  end
  if p_entity.position.y + p_entity.rayon >= hauteur then
    p_entity.position.Set_Y(hauteur-p_entity.rayon)
    p_entity.velocite.Set_Y(p_entity.velocite.Get_Y()*rebunding)
  elseif p_entity.position.y - p_entity.rayon <= 0 then
    p_entity.position.Set_Y(p_entity.rayon)
    p_entity.velocite.Set_Y(p_entity.velocite.Get_Y()*rebunding)
  end
end

-- Si un cercle sort par un bord de l'écran, il réapparait par le bord opposé.
function Regen_Circle(p_entity)
  if p_entity.position.x >= largeur + p_entity.rayon then
    p_entity.position.Set_X(-p_entity.rayon)
  elseif p_entity.position.x <= -p_entity.rayon then
    p_entity.position.Set_X(largeur + p_entity.rayon)
  end
  if p_entity.position.y >= hauteur + p_entity.rayon then
    p_entity.position.Set_Y(-p_entity.rayon)
  elseif p_entity.position.y <=  - p_entity.rayon then
    p_entity.position.Set_Y(hauteur + p_entity.rayon)
  end
end

-- Fait rebondir un rectangle sur les bords de l'écran.
function Bounce_Rect(p_entity, rebunding)
  if p_entity.position.x + p_entity.size.x >= largeur then
    p_entity.position.Set_X(largeur-p_entity.size.x)
    p_entity.velocite.Set_X(p_entity.velocite.Get_X()*rebunding)
  elseif p_entity.position.x - p_entity.size.x <= 0 then
    p_entity.position.Set_X(p_entity.size.x)
    p_entity.velocite.Set_X(p_entity.velocite.Get_X()*rebunding)
  end
  if p_entity.position.y + p_entity.size.y >= hauteur then
    p_entity.position.Set_Y(hauteur-p_entity.size.y)
    p_entity.velocite.Set_Y(p_entity.velocite.Get_Y()*rebunding)
  elseif p_entity.position.y - p_entity.size.y <= 0 then
    p_entity.position.Set_Y(p_entity.size.y)
    p_entity.velocite.Set_Y(p_entity.velocite.Get_Y()*rebunding)
  end
end

-- Si un rectangle sort par un bord de l'écran, il réapparait par l'autre bord.
function Regen_Rect(p_entity)
  if p_entity.position.x >= largeur + p_entity.size.x then
    p_entity.position.Set_X(-p_entity.size.x)
  elseif p_entity.position.x <= -p_entity.size.x then
    p_entity.position.Set_X(largeur + p_entity.size.x)
  end
  if p_entity.position.y >= hauteur + p_entity.size.y then
    p_entity.position.Set_Y(-p_entity.size.y)
  elseif p_entity.position.y <=  - p_entity.size.y then
    p_entity.position.Set_Y(hauteur + p_entity.size.y)
  end
end

-----------------------------------------------------------------------------------------------

-- Fonction qui dessine progressivement un graphique en 
-- forme de cloche.
function Draw_Bell_Curve()
  results = {}
  for i=0, 100 do
    results[i] = 0
  end
  local ghost = {}
  ghost.Add_Result = function()
    local iterations = 3
    local total = 0
    for i = 0, iterations-1 do
      total = total + Random_Range(0, 100)
    end
    result = math.floor(total/iterations)
    results[result] = results[result]+1
  end

  ghost.Draw_Curve = function()
    w = largeur/100
    for i=1, 100 do
      h = results[i] * -10
      love.graphics.rectangle("fill", w*i, hauteur, w, h)
    end
  end
  return ghost
end

---------------------------------------------------------------------------------------------------------------

-- Lie deux points par une force élastique.
function Create_Spring(p_ancre_x, p_ancre_y, p_weight_x, p_weight_y, p_weight_rayon, p_weight_speed, p_weight_direction, k, p_weight_friction)
  local spring_p = Vector(p_ancre_x, p_ancre_y)
  local weight = Particule(p_weight_x, p_weight_y, 0, 0, p_weight_rayon, 0, 0, 0, 0, p_weight_speed, p_weight_direction, 0)
  weight.friction = p_weight_friction
  local ghost = {}
  ghost.New_Spring_Pos = function(mx, my)
    spring_p.Set_X(mx)
    spring_p.Set_Y(my)
  end
  ghost.Update = function(dt)
    local dist = spring_p - weight.position
    local spring_f = dist*k
    weight.velocite.Add_To(spring_f)
    weight.Update(dt)
  end
  ghost.Draw = function()
    love.graphics.circle("fill", weight.position.Get_X(), weight.position.Get_Y(), weight.rayon)
    love.graphics.circle("fill", spring_p.Get_X(), spring_p.Get_Y(), 10)
    love.graphics.line(weight.position.Get_X(), weight.position.Get_Y(), spring_p.Get_X(), spring_p.Get_Y())
  end
  return ghost
end

-- Crée une force élastique entre deux particuless.
function Spring(p1, p2, p_separation, p_k)
  local dist = p1.position - p2.position
  dist.Set_Norme(dist.Get_Norme()-p_separation)
  local spring_force = dist * p_k
  p2.velocite.Add_To(spring_force)
  p1.velocite.Subtract_To(spring_force)
end

-- Vérifie qu'une particule ne sorte pas des limites de l'écran
-- et la remet dans le droit chemin sinon.
function Check_Edges(p)
  if p.position.Get_X()+p.rayon > largeur then
    p.position.Set_X(largeur-p.rayon)
    p.velocite.Set_X(p.velocite.Get_X()*-0.95)
  end
  if p.position.Get_X()-p.rayon < 0 then
    p.position.Set_X(p.rayon)
    p.velocite.Set_X(p.velocite.Get_X()*-0.95)
  end
  if p.position.Get_Y()+p.rayon > hauteur then
    p.position.Set_Y(hauteur-p.rayon)
    p.velocite.Set_Y(p.velocite.Get_Y()*-0.95)
  end
end

-- Défini certaines caractéristiques d'une particule.
function Set_Flow_Element(p_part)
  p_part.rayon = 7
  p_part.Set_Speed(Random_Range(7, 8))
  p_part.Set_Heading(math.pi/2+Random_Range(-0.1, 0.1))
end

-- Objet qui fait graviter un flot de particules autour d'un ou plusieurs
-- point d'attractions qui sont passés en paramètre de l(objet par
-- l'intermédiaire d'une table.
function Create_Flow(p_table, p_nb, px, py)
  local emitter = {}
  emitter.x = px
  emitter.y = py
  local particules = {}
  local nb_particules = p_nb
  
  for i=1,nb_particules do
    p = Particule(emitter.x, emitter.y, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    Set_Flow_Element(p)
    for i=1,#p_table do
      local s = p_table[i]
      p.Add_Gravitation(s)
    end
    table.insert(particules, p)
  end
  
  local ghost = {}
  ghost.Update = function(dt)
    for i=1,nb_particules do
      local p = particules[i]
      p.Update(dt)
      if p.position.x < 0 or p.position.x > largeur or p.position.y < 0 or p.position.y > hauteur then
        p.position.Set_X(emitter.x)
        p.position.Set_Y(emitter.y)
        Set_Flow_Element(p)
      end
    end
  end
  ghost.Draw = function()
    for i=1,#p_table do
      love.graphics.setColor(1, 1, 0)
      local s = p_table[i]
      love.graphics.circle("fill", s.position.Get_X(), s.position.Get_Y(), s.rayon)
    end
    love.graphics.setColor(1, 1, 1)
    for i=1,nb_particules do
      local p = particules[i]
      love.graphics.circle("fill", p.position.Get_X(), p.position.Get_Y(), p.rayon)
    end
  end
  return ghost
end

-- Crée une sorte de bruit blanc comme des parasites de TV.
function White_Noise_TV(px, py, pmax_r, p_nombre)
  local white_point = {}
  local nb_white_point = p_nombre
  for i=1,nb_white_point do
    local p = {}
    p.rayon = math.sqrt(love.math.random()) * pmax_r
    local angle = Random_Range(0, math.pi*2)
    p.x = px + math.cos(angle) * p.rayon
    p.y = py + math.sin(angle) * p.rayon
    table.insert(white_point, p)
  end
  local ghost = {}
  ghost.Update = function(dt)
    for i=1,#white_point do
      local p = white_point[i]
      p.rayon = math.sqrt(love.math.random()) * pmax_r
      angle = Random_Range(0, math.pi*2)
      p.x = px + math.cos(angle) * p.rayon
      p.y = py + math.sin(angle) * p.rayon
    end
  end
  ghost.Draw = function()
    for i=1,#white_point do
      local p = white_point[i]
      love.graphics.circle("fill", p.x, p.y, 1)
    end
  end
  return ghost
end

-- Crée une explosion dont le champ d'occupation des particules est carré.
function Explosion_Carree(nb_parts, etendue)
  particules = {}
  for i=1,nb_parts do
    p = Particule(largeur/2, hauteur/2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    p.velocite.x = Random_Range(-etendue, etendue)
    p.velocite.y = Random_Range(-etendue, etendue)
    table.insert(particules, p)
  end
  local ghost = {}
  ghost.Update = function(dt)
    for i=1, #particules do
      local p = particules[i]
      p.Update(dt)
    end
  end
  ghost.Draw = function()
    for i=1,#particules do
      local p = particules[i]
      love.graphics.circle("fill", p.position.x, p.position.y, 3)
    end
  end
  return ghost
end

-- Dispose des points en cercle.
function Display_Points_On_Circle(nb_points, px, py, p_rayon_cercle, p_rayon_particule)
  local rond = {}
  for i=1,nb_points do
    local p = {}
    p.angle = math.pi*2 / nb_points*i
    p.x = px + math.cos(p.angle) * p_rayon_cercle
    p.y = py + math.sin(p.angle) * p_rayon_cercle
    table.insert(rond, p)
  end
  local ghost = {}
  ghost.Draw = function()
    for i=1,#rond do
      local p = rond[i]
      love.graphics.circle("fill", p.x, p.y, p_rayon_particule)
    end
  end
  return ghost
end

-----------------------------------------------------

-- Crée une suite de points qui se dirige vers le curseur de 
-- la souris.
function Snake_Point(p_nb_ronds, p_ease)
  local target = {}
  target.x = 0
  target.y = 0
  local leader = {}
  leader.x = target.x
  leader.y = target.y
  local lst_ronds = {}
  local nb_ronds = p_nb_ronds
  local ease = p_ease
  for i=1,nb_ronds do
    local p = {}
    p.x = 0
    p.y = 0
    table.insert(lst_ronds, p)
  end
  local ghost = {}
  ghost.Update = function(dt)
    local mouse_x, mouse_y = love.mouse.getPosition()
    if love.mouse.isDown(1) then
      target.x = mouse_x
      target.y = mouse_y
    end
    
    leader.x = target.x
    leader.y = target.y
    for i=1,#lst_ronds do
      local r = lst_ronds[i]
      r.x = r.x + (leader.x-r.x) * ease
      r.y = r.y + (leader.y-r.y) * ease
      
      leader.x = r.x
      leader.y = r.y
    end
  end
  ghost.Draw = function()
    for i=1,#lst_ronds do
      local r = lst_ronds[i]
      Draw_Points(r, 5)
    end
  end
  return ghost
end

-- Crée une ligne qui serpente vers le curseur de la souris.
function Ease_Line(tx, ty, p_ronds, p_ease)
  local target = {}
  target.x = tx
  target.y = ty
  local leader = {}
  leader.x = target.x
  leader.y = target.y
  local ease = p_ease
  local nb_ronds = p_ronds
  local lst_ronds = {}
  for i=1,nb_ronds do
    local r = {}
    r.x = 0
    r.y = 0
    table.insert(lst_ronds, r)
  end
  
  local ghost = {}
  ghost.Update = function(dt)
    leader.x = target.x
    leader.y = target.y
    
    for i=1,#lst_ronds do
      local p = lst_ronds[i]
      p.x = p.x + (leader.x - p.x) * ease
      p.y = p.y + (leader.y - p.y) * ease
      
      leader.x = p.x
      leader.y = p.y
    end
  end
  ghost.Draw = function()
    for i=1,#lst_ronds-1 do
      love.graphics.line(lst_ronds[i].x, lst_ronds[i].y, lst_ronds[i+1].x, lst_ronds[i+1].y)
    end
  end
  ghost.Mouse_Pressed = function(x, y, button)
    target.x = x
    target.y = y
  end
  return ghost
end