--[[

    recenser ici toutes ce qui tourne autour de fonctions mathématiques. Ensuite il faudra
    refaire plusieurs fichiers distincts, regroupant les fonctionnalités de manière thématique.

]]




    -- Tirage au hasard dans une liste.
    
io.stdout:setvbuf('no')
if arg[arg] == "-debug" then require("mobdebug").start() end

function love.load()
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  
  liste = {}
  for i=1,10 do
    liste[i] = {}
    liste[i].valeur = i
    liste[i].couleur = "noire"
  end
  for i=11,20 do
    liste[i] = {}
    liste[i].valeur = i
    liste[i].couleur = "rouge"
  end
  
  --Melange(liste)
  
  tirage = love.math.random(1, #liste)
end

function love.update(dt)
  
end

function love.draw()
  love.graphics.setBackgroundColor(0.5, 0.5, 0.5)
  x = 10
  for i=1,#liste do
    if liste[i].couleur == "noire" then
      love.graphics.setColor(0, 0, 0)
    elseif liste[i].couleur == "rouge" then
      love.graphics.setColor(1, 0, 0)
    end
    love.graphics.print(liste[i].valeur, x, 10)
    x = x + 25
  end
  
  love.graphics.setColor(1, 1, 1)
  love.graphics.print(tirage, 10, 25)
end

function love.keypressed(key)
  if key == "space" then
    Melange(liste)
  end
end

function Melange(pListe)
  for m=1,500 do
    local c1 = love.math.random(1, #pListe)
    local c2 = love.math.random(1, #pListe)
    local temp = pListe[c1]
    pListe[c1] = pListe[c2]
    pListe[c2] = temp
  end
end

--[[____________________________________________________________________________________________________________________
________________________________________________________________________________________________________________________
]]

    -- Application d'une inertie à un sprite.
    
io.stdout:setvbuf('no')
if arg[arg] == "-debug" then require("mobdebug").start() end

function love.load()
  perso = {}
  perso.x = 10
  perso.y = 300
  perso.r = 5
  perso.speed_x = 0
  perso.speed_y = 0
  
  max_speed = 6
end

function love.update(dt)
  if math.abs(perso.speed_x) < max_speed then
    if love.keyboard.isDown("right") then
      perso.speed_x = perso.speed_x + 0.2
    end
    if love.keyboard.isDown("left") then
      perso.speed_x = perso.speed_x - 0.2
    end
  end
  if math.abs(perso.speed_y) < max_speed then
    if love.keyboard.isDown("up") then
      perso.speed_y = perso.speed_y - 0.2
    end
    if love.keyboard.isDown("down") then
      perso.speed_y = perso.speed_y + 0.2
    end
  end
  perso.x = perso.x + perso.speed_x
  perso.y = perso.y + perso.speed_y
  perso.speed_x = perso.speed_x * 0.9
  perso.speed_y = perso.speed_y * 0.9
  if math.abs(perso.speed_x) < 0.1 then
    perso.speed_x = 0
  end
  if math.abs(perso.speed_y) < 0.1 then
    perso.speed_y = 0
  end
end

function love.draw()
  love.graphics.circle("fill", perso.x, perso.y, perso.r)
end

function love.keypressed(key)
  
end

--[[____________________________________________________________________________________________
________________________________________________________________________________________________
]]

    -- Système basique de jet-pack
    
io.stdout:setvbuf('no')
if arg[arg] == "-debug" then require("mobdebug").start() end

function love.load()
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  est_allume = false
  
  joueur = {}
  joueur.x = 100
  joueur.y = 300
  joueur.w = 20
  joueur.h = 20
  
  sol = {}
  sol.x1 = 0
  sol.y1 = 550
  sol.x2 = largeur
  sol.y2 = 550
end

function love.update(dt)
  est_allume = false
  if love.keyboard.isDown("up") then
    est_allume = true
    joueur.y = joueur.y - 5
  end
  if love.keyboard.isDown("right") then
    joueur.x = joueur.x + 5
  end
  if love.keyboard.isDown("left") then
    joueur.x = joueur.x - 5
  end
  if joueur.y+joueur.h <= sol.y1 then
    joueur.y = joueur.y + 2
  end
end

function love.draw()
  love.graphics.rectangle("fill", joueur.x, joueur.y, joueur.w, joueur.h)
  if est_allume then
    love.graphics.setColor(1, 0, 0)
    love.graphics.polygon("fill", joueur.x+2, joueur.y+joueur.h, joueur.x+joueur.w-2, joueur.y+joueur.h, joueur.x+(joueur.w/2), joueur.y+joueur.h+10)
    love.graphics.setColor(1, 1, 1)
  end
  
  love.graphics.line(sol.x1, sol.y1, sol.x2, sol.y2)
end

--[[______________________________________________________________________________________________________
___________________________________________________________________________________________________________
]]

    -- Système qui fait tourner un sprite autour d'un autre.
    
io.stdout:setvbuf('no')
if arg[arg] == "-debug" then require("mobdebug").start() end

function love.load()
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  
  flocon_img = love.graphics.newImage("diamond.png")
  
  soleil = {}
  soleil.img = love.graphics.newImage("star_2.png")
  soleil.w = soleil.img:getWidth()
  soleil.h = soleil.img:getHeight()
  soleil.x = 0
  soleil.y = 0
  soleil.ox = soleil.w/2
  soleil.oy = soleil.h/2
  soleil.angle = 0
  soleil.decalage = 200
  
  lune = {}
  lune.img = love.graphics.newImage("coin.png")
  lune.w = soleil.img:getWidth()
  lune.h = soleil.img:getHeight()
  lune.x = 0
  lune.y = 0
  lune.ox = lune.w/2
  lune.oy = lune.h/2
  lune.angle = soleil.angle
  lune.decalage = soleil.decalage
  
  angle_flocon = 0
  x_flocon = 100
  y_flocon = 0
end

function love.update(dt)
  soleil.angle = soleil.angle + 0.01
  soleil.x = soleil.decalage * math.cos(soleil.angle)
  soleil.y = soleil.decalage * math.sin(soleil.angle)
  
  lune.x = soleil.decalage * math.cos(soleil.angle + math.pi)
  lune.y = soleil.decalage * math.sin(soleil.angle + math.pi)
  
  angle_flocon = angle_flocon + 0.1
  y_flocon = y_flocon + 2
  x_flocon = 100
  x_flocon = x_flocon + (20 * math.sin(angle_flocon))
end

function love.draw()
  love.graphics.push()
  love.graphics.setScissor(149, 49, largeur-298, hauteur/2-48)
  love.graphics.draw(soleil.img, soleil.x + (largeur/2), soleil.y + (hauteur/2), 0, 1, 1, soleil.ox, soleil.oy)
  love.graphics.draw(lune.img, lune.x + (largeur/2), lune.y + (hauteur/2), 0, 1, 1, lune.ox, lune.oy)
  
  love.graphics.setColor(0, 1, 0)
  love.graphics.rectangle("line", 150, 50, largeur-300, hauteur/2-50)
  
  love.graphics.setColor(1, 0, 0)
  love.graphics.circle("fill", largeur/2, hauteur/2, 2)
  love.graphics.setColor(1, 1, 1)
  love.graphics.setScissor()
  love.graphics.pop()
  
  love.graphics.draw(soleil.img, largeur/2, 450)
  love.graphics.draw(flocon_img, x_flocon, y_flocon)
end

--[[_____________________________________________________________________________________________
_________________________________________________________________________________________________
]]

    -- Création et affichage d'une courbe à l'aide d'une fonction sinus.
    
io.stdout:setvbuf('no')
if arg[arg] == "-debug" then require("mobdebug").start() end

function love.load()
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  
  angle = 0
  x = 0
  y = 0
  p = {}
end

function love.update(dt)
  angle = angle + 0.2
  y = math.sin(angle) * 10
  x = x + 3
  
  xp = x + 100 * math.cos(x/20)
end

function love.draw()
  y = y + (hauteur/2)
  
  love.graphics.circle("fill", xp, y, 4)
  table.insert(p, {_x = xp, _y = y})
  
  for k,v in pairs(p) do
    love.graphics.points(v._x, v._y)
  end
end

--------------------------------------------------------

-- Fonction qui calcul l'opposé de la tangente en prenant en compte
-- les cas dans lesquels x = 0.
function Arc_Tan_2(pX, pY)
  if pX == 0 then
    if pY < 0 then
      return - math.pi/2
    else
      return math.pi/2
    end
  end
  if pX > 0 then
    return math.atan(pY/pX)
  end
  if pX < 0 then
    return math.pi + math.atan(pY/pX)
  end
end

-- Fonction qui adpte proportionnellement une valeur sur une échelle donnée.
-- Elle prend en paramètres une valeur quelconque et deux autres valeurs qui
-- vont servir de minimum et de maximum à l'echelle sur laquelle on projeter
-- la valeur de départ.
function Norm_Number(pValue, pMin, pMax)
  return (pValue-pMin)/(pMax-pMin)
end

-- Fonction d'interpolation linéaire. Elle fait le contraire de la fonction norm. Ele
-- prend une valeur normalisée sur une échelle et renvoie le nombre auquel elle
-- correspond sur cete échelle.
function Lerp(pNorm, pMin, pMax)
  return (pMax-pMin)*pNorm + pMin
end

-- Fonction qui prend une valeur sur une échelle, la normalise puis la convertie en une
-- valeur proportionnelle sur une autre échelle.
function Map(pValue, pSource_Min, pSource_Max, pDestin_Min, pDestin_Max)
  return Lerp(Norm_Number(pValue, pSource_Min, pSource_Max), pDestin_Min, pDestin_Max)
end

-- Fonction qui permet de caper une valeur sur une échellle de valeurs données. Elle
-- prend en paramètres la valeur à caper et les valeurs minimum et maximum sur lesquelles
-- la valeur de départ doit être capée. Pour cela on retourne le minimum entre le maximum
-- de la valeur de départ ou la valeur basse du range et la valeur max du range.
function Clamp(pValue, pMin, pMax)
  return math.min(math.max(pValue, pMin), pMax)
end

-----------------------------------------------------------------

function Deg_To_Rad(degres)
  return degres/180 * math.pi
end

function Rad_To_Deg(radians)
  return radians*180 / math.pi
end

function Round_To_Places(value, places)
  mult = math.pow(10, places)
  return math.floor(value*mult)/mult
end

function Round_Nearest(value, nearest)
  return math.floor(value/nearest) * nearest
end

function Random_Range(pMin, pMax)
  return pMin + love.math.random()*(pMax-pMin)
end

function Random_Int(pMin, pMax)
  return math.floor(pMin + love.math.random()*(pMax-pMin+1))
end

function Random_Dist(pMin, pMax, pIterations)
  local total = 1
  for i=1, pIterations do
    total = total + Random_Range(pMin, pMax)
  end
  return total/pIterations
end

----------------------------------------------------------------------------------------------

-- Echange les valeurs entre deux variables.
function Swap(a, b)
  local temp = a
  a = b
  b = temp
  return a, b
end

-- Génère un nombre aléatoire.
function RND()
  return love.math.random()
end

--Tiemr

function Chrono(time, callback)
  local expired = false
  local timer = {}
  
  function timer.update(dt)
    if time < 0 then
      expired = true
      callback()
    end
    time = time-dt
    return time
  end
  
  function timer.is_Expired()
    return expired
  end
  
  return timer
end

---------------------------------------------------------------------------

function FlipSprite(pSprite)
  pSprite.x = pSprite.x + pSprite.speed
  
  if pSprite.x-pSprite.width <= 0 or pSprite.x >= WIDTH-pSprite.width then
    franchir_bord = true
  else
    franchir_bord = false
  end
  
  if franchir_bord == true then
    pSprite.speed = pSprite.speed*(-1)
  end
end

---------------------------------------------------------------------------------

function Dot(v1, v2)
  return v1.x*v2.x + v1.y*v2.y
end

-- fonction qui calcule le cross product de deux vecteurs.
function Determinant(v1, v2)
  return v1.x*v2.y - v1.y*v2.x
end

-- fonction qui normalise deux vecteurs avant de calculer leur dot product.
function Dot_Normalized(v1, v2)
  v1.normalize()
  v2.normalize()
  return Dot(v1, v2)
end

-- fonction qui place un point non plus en fonction de l'origine mais à partir d'un nouveau système
-- de coordonnées.
function Local_To_World(local_origine, point, r)
  local new_point = Vector(point.x, point.y)
  new_point.Set_Angle(r.Get_Angle()+point.Get_Angle())
  return local_origine+new_point
end

-- Crée un nouveau système de coordonnées représenté à l'écran par deux lignes.
function New_Coord_System(x, y, longueur_repere, angle)
  local ghost = {}
  ghost.pos = Vector(x, y)
  ghost.axe_x = Vector(ghost.pos.x+longueur_repere, ghost.pos.y)
  ghost.axe_y = Vector(ghost.pos.x, ghost.pos.y+longueur_repere)
  ghost.angle = angle
  ghost.rotation_x = Vector(0, 0)
  ghost.rotation_y = Vector(0, 0)
  ghost.Update = function(dt, key_up, key_down)
    if love.keyboard.isDown(key_up) then
      ghost.angle = ghost.angle + 0.01
    end
    if love.keyboard.isDown(key_down) then
      ghost.angle = ghost.angle - 0.01
    end
    ghost.rotation_x = Vector(longueur_repere*math.cos(ghost.angle), longueur_repere*math.sin(ghost.angle))
    ghost.rotation_y = Vector(longueur_repere*math.cos(ghost.angle+math.pi/2), longueur_repere*math.sin(ghost.angle+math.pi/2))
    
    ghost.axe_x.x = ghost.pos.x+ghost.rotation_x.x
    ghost.axe_x.y = ghost.pos.y+ghost.rotation_x.y
    
    ghost.axe_y.x = ghost.pos.x+ghost.rotation_y.x
    ghost.axe_y.y = ghost.pos.y+ghost.rotation_y.y
  end
  ghost.Draw = function(color_1)
    love.graphics.setColor(color_1)
    love.graphics.line(ghost.pos.x, ghost.pos.y, ghost.axe_x.x, ghost.axe_x.y)
    love.graphics.line(ghost.pos.x, ghost.pos.y, ghost.axe_y.x, ghost.axe_y.y)
    love.graphics.print("x", ghost.axe_x.x, ghost.axe_x.y)
    love.graphics.print("y", ghost.axe_y.x, ghost.axe_y.y)
    love.graphics.setColor(1, 1, 1)
  end
  return ghost
end

-- Converti les coordonnées d'un point entre une position globale et locale
function Convert_Point(x, y)
  local ghost = {}
  ghost.point = Vector(0, 0)
  ghost.pos = Vector(x, y)
  ghost.id = "global"
  ghost.Update = function(dt, new_origine, up, right, down, left)
    ghost.convert = Local_To_World(new_origine.pos, ghost.pos, new_origine.rotation_x)
    if ghost.id == "global" then
      ghost.point = ghost.pos
    elseif ghost.id == "local" then
      ghost.point = ghost.convert
    end
    
    if love.keyboard.isDown(up) then
      ghost.pos.y = ghost.pos.y - 10
    end
    if love.keyboard.isDown(right) then
      ghost.pos.x = ghost.pos.x + 10
    end
    if love.keyboard.isDown(down) then
      ghost.pos.y = ghost.pos.y + 10
    end
    if love.keyboard.isDown(left) then
      ghost.pos.x = ghost.pos.x - 10
    end
  end
  ghost.Draw = function(color)
    love.graphics.setColor(color)
    love.graphics.circle("fill", ghost.point.x, ghost.point.y, 10)
    love.graphics.setColor(1, 1, 1)
  end
  ghost.Keypressed = function(key, switch)
    if key == switch then
      if ghost.id == "global" then
        ghost.id = "local"
      elseif ghost.id == "local" then
        ghost.id = "global"
      end
    end
  end
  return ghost
end

-- fonction qui renvoie la localisation d'un point par rapport à un système de coordonnées alternatif.
function Return_Local_Coords(point, origine)
  local relative_coords = point-origine.pos
  local norm_x = origine.rotation_x
  local norm_y = origine.rotation_y
  norm_x.normalize()
  norm_y.normalize()
  local x = Dot(relative_coords, norm_x)
  local y = Dot(relative_coords, norm_y)
  return Vector(x, y)
end

-- fonction qui permet de vérifier si un vecteur regarde dans une certaine direction.
function Is_Looking_For(origine, mobile, bras)
  local mobile_to_origine = origine-mobile
  mobile_to_origine.normalize()
  local mobile_direction = Vector(bras.w*math.cos(bras.rotation), bras.w*math.sin(bras.rotation))
  mobile_direction.normalize()
  local is_looking = Dot_Normalized(mobile_direction, mobile_to_origine)
  if is_looking > 0.995 then
    return true
  end
  return false
end