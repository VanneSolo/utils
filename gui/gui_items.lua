--[[

    Fichier qui va contenir tout ce qui ressemble à de l'interface utilisateur. La librairie
    d'ui déjà existante se trouvera dans un sous dossier. Etape suivante: fignoler la lib d'ui.

]]

io.stdout:setvbuf('no')
if arg[arg] == "-debug" then require("mobdebug").start() end

function love.load()
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  
  joueur = {}
  joueur.r = 20
  joueur.x = largeur/2
  joueur.y = hauteur-joueur.r
  joueur.vitesse = 5
  
  barre_de_vie = {}
  barre_de_vie.w = 50
  barre_de_vie.h = 5
  barre_de_vie.x = joueur.x - (barre_de_vie.w/2)
  barre_de_vie.y = joueur.y - joueur.r - 10
  
  points_vie = {}
  points_vie.max = 150
  points_vie.actuel = 150
end

function love.update(dt)
  ratio = points_vie.actuel/points_vie.max
  
  if points_vie.actuel <= points_vie.max then
    points_vie.actuel = points_vie.actuel + 0.05
  end
  
  if love.keyboard.isDown("up") then
    joueur.y = joueur.y - joueur.vitesse
  end
  if love.keyboard.isDown("right") then
    joueur.x = joueur.x + joueur.vitesse
  end
  if love.keyboard.isDown("down") then
    joueur.y = joueur.y + joueur.vitesse
  end
  if love.keyboard.isDown("left") then
    joueur.x = joueur.x - joueur.vitesse
  end
  barre_de_vie.x = joueur.x - (barre_de_vie.w/2)
  barre_de_vie.y = joueur.y - joueur.r - 10
end

function love.draw()
  love.graphics.circle("fill", joueur.x, joueur.y, joueur.r)
  
  love.graphics.rectangle("fill", barre_de_vie.x, barre_de_vie.y, barre_de_vie.w, barre_de_vie.h)
  if ratio > 0.6 then
    love.graphics.setColor(0, 1, 0)
  elseif ratio > 0.3 then
    love.graphics.setColor(0.8, 0.3, 0)
  else
    love.graphics.setColor(1, 0, 0)
  end
  love.graphics.rectangle("fill", barre_de_vie.x+1, barre_de_vie.y+1, (barre_de_vie.w-2)*ratio, barre_de_vie.h-2)
  love.graphics.setColor(1, 1, 1)
end

function love.keypressed(key)
  if key == "space" then
    if points_vie.actuel >= 5 then
      points_vie.actuel = points_vie.actuel - 5
    elseif points_vie.actuel < 5 and points_vie.actuel >= 1 then
      points_vie.actuel = points_vie.actuel - 1
    end
  end
end

--[[_______________________________________________________________________________________________________________________
___________________________________________________________________________________________________________________________
]]

    -- Système qui transforme la fenêtre en console.
    
    -- main.lua
    
function love.load()
  console = require "console"
  
  console.Init(30, 25, 25)
  console.Write_Line("BONJOUR, ")
  console.Write_Line("TU PUES LA MERDE A CHIER")
end

function love.update(dt)
  
end

function love.draw()
  console.Draw()
end

function love.keypressed(key)
  if key == "space" then
    console.Write_Line(tostring(os.time()))
  end
end

    -- console.lua
    
local Console = {}

Console.line = 0
Console.coll = 0
Console.grille = nil

Console.cursor = {}
Console.cursor.line = 1
Console.cursor.coll = 1

function Console.Init(pLine, pColl, pHeightPixel)
  Console.line = pLine
  Console.coll = pColl
  
  Console.font = love.graphics.newFont("04B_03B_.TTF", pHeightPixel, "none")
  love.graphics.setFont(Console.font)
  Console.char_width = Console.font:getWidth("W")
  Console.char_height = Console.font:getHeight("W")
  
  love.window.setMode(pColl*Console.char_width, pLine*Console.char_height)
  
  Console.canvas = love.graphics.newCanvas(pColl*Console.char_width, pLine*Console.char_height)
  Console.grille = {}
  for l=1,pLine do
    Console.Clear_Line(l)
  end
  
  Console.Update_Canvas()
end

function Console.Write_Line(pTexte)
  local n = 1
  for c=Console.cursor.coll,Console.cursor.coll+string.len(pTexte) do
    local char = string.sub(pTexte, n, n)
    Console.grille[Console.cursor.line][c] = char
    n = n + 1
  end
  Console.Next_Line()
  Console.Update_Canvas()
end

function Console.Next_Line()
  Console.cursor.line = Console.cursor.line + 1
  Console.cursor.coll = 1
  if Console.cursor.line > Console.line then
    Console.Scroll()
    Console.cursor.line = Console.line
  end
end

function Console.Clear_Line(pLine)
  Console.grille[pLine] = {}
  for c=1,Console.coll do
    Console.grille[pLine][c] = " "
  end
end

function Console.Scroll()
  for l=2,Console.line do
    Console.grille[l-1] = Console.grille[l]
  end
  Console.Clear_Line(Console.line)
  Console.Update_Canvas()
  if Console.cursor.line > 1 then
    Console.cursor.line = Console.cursor.line - 1
  end
end

function Console.Update_Canvas()
  love.graphics.setCanvas(Console.canvas)
  love.graphics.clear()
  love.graphics.setColor(1, 1, 1)
  for l=1,Console.line do
    for c=1,Console.coll do
      local offset = Console.char_width - Console.font:getWidth(Console.grille[l][c])
      love.graphics.print(Console.grille[l][c], ((c-1)*Console.char_width)+offset, (l-1)*Console.char_height)
    end
  end
  love.graphics.setCanvas()
end

function Console.Draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(Console.canvas)
  love.graphics.rectangle("fill", (Console.cursor.coll-1)*Console.char_width, (Console.cursor.line-1)*Console.char_height, Console.char_width, Console.char_height)
end

return Console

--[[____________________________________________________________________________________________________________________
________________________________________________________________________________________________________________________
]]

    -- Gestion des entrées clavier.
    
io.stdout:setvbuf('no')
if arg[arg] == "-debug" then require("mobdebug").start() end

utf_8 = require("utf8")

function love.load()
  texte = ""
  message = ""
  input_pseudo = false
end

function love.update(dt)
  
end

function love.draw()
  if input_pseudo then
    love.graphics.print("Entrez votre pseudo > "..texte, 10, 10)
    love.graphics.print(message, 10, 25)
  end
end

function love.keypressed(key)
  if key == "backspace" then
    message = ""
    local p = utf_8.offset(texte, -1)
    if p then
      texte = string.sub(texte, 1, p-1)
    end
  end
  if key == "return" and input_pseudo then
    if string.len(texte) >= 5 then
      if string.len(texte) <=10 then
        print("Le pseudo est: "..texte)
        input_pseudo = false
      else
      message = "Le pesudo est trop long"
      end
    else
      message = "Pas assez de caractères."
    end
  end
end

function love.textinput(t)
  if input_pseudo == false then
    return
  end
  texte = texte..t
  --message = ""
end

function love.mousepressed(x, y, button)
  if button == 1 then
    Ajoute_Pseudo()
    message = ""
  end
end

function Ajoute_Pseudo()
  texte = ""
  message = ""
  input_pseudo = true
end

--[[__________________________________________________________________________________________________
______________________________________________________________________________________________________
]]

    -- Système qui fait pop un score au dessus d'un sprite.
    
io.stdout:setvbuf('no')
if arg[arg] == "-debug" then require("mobdebug").start() end

function love.load()
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  
  font_normal = love.graphics.getFont()
  font_game = love.graphics.newFont("Alien Remix.ttf", 16)
  
  liste_pop_score = {}
  liste_particules = {}
  
  pop_lifetime = 1
  explosion_lifetime = 1
end

function love.update(dt)
  Update_Pop_Score(dt)
  Update_Particules(dt)
end

function love.draw()
  love.graphics.setFont(font_game)
  Affiche_Pop_Score()
  Affiche_Particules()
  --love.graphics.setFont(font_normal)
end

function love.keypressed(key)
  
end

function love.mousepressed(x, y)
  Ajoute_Pop_Score(1000, x, y-30)
  for i=1,50 do
    Ajoute_Particule(x, y, 3)
  end
end

function Init_Game()
  liste_pop_score = {}
end

function Ajoute_Pop_Score(pScore, pX, pY)
  local score = {}
  score.valeur = pScore
  local largeur_text = font_game:getWidth(tostring(score.valeur))
  score.x = pX - (largeur_text/2)
  score.y = pY
  score.lifetime = 0
  table.insert(liste_pop_score, score)
end

function Update_Pop_Score(dt)
  for i=#liste_pop_score,1,-1 do
    local pop = liste_pop_score[i]
    pop.y = pop.y - 1
    pop.lifetime = pop.lifetime + dt
    if pop.lifetime > pop_lifetime then
      table.remove(liste_pop_score, i)
    end
  end
end

function Affiche_Pop_Score()
  for i=1,#liste_pop_score do
    local pop = liste_pop_score[i]
    local alpha = 1 - (pop.lifetime/pop_lifetime)
    love.graphics.setColor(1, 1, 1, alpha)
    love.graphics.print(pop.valeur, pop.x, pop.y)
    love.graphics.setColor(1, 1, 1, 1)
  end
end

function Ajoute_Particule(pX, pY, pR)
  local particule = {}
  particule.x = pX
  particule.y = pY
  particule.r = pR
  particule.lifetime = 0
  particule.vx = love.math.random(-100, 100)
  particule.vy = love.math.random(-100, 100)
  table.insert(liste_particules, particule)
end

function Update_Particules(dt)
  for i=#liste_particules,1,-1 do
    local particule = liste_particules[i]
    particule.x = particule.x + particule.vx*dt
    particule.y = particule.y - particule.vy*dt
    particule.lifetime = particule.lifetime + dt
    if particule.lifetime > explosion_lifetime then
      table.remove(liste_particules, i)
    end
  end
end

function Affiche_Particules()
  for i=1,#liste_particules do
    local particule = liste_particules[i]
    local alpha = 1 - (particule.lifetime/explosion_lifetime)
    love.graphics.setColor(0.8, 0.2, 0, alpha)
    love.graphics.circle("fill", particule.x, particule.y, particule.r)
    love.graphics.setColor(0.8, 0.2, 0, alpha)
  end
end

--[[__________________________________________________________________________________________________________
______________________________________________________________________________________________________________
]]

    -- Système de scrolling
    
io.stdout:setvbuf('no')
if arg[arg] == "-debug" then require("mobdebug").start() end

function love.load()
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  
  liste_carres = {}
  for i=1,12 do
    carre = {}
    carre.x = 73
    carre.y = 500
    carre.w = 20
    table.insert(liste_carres, carre)
  end
  
  scroll = 0
end

function love.update(dt)
  scroll = scroll - 1
  if scroll <= -largeur then
    scroll = 0
  end
end

function love.draw()
  for i=1, #liste_carres do
    love.graphics.rectangle("fill", ((i-1)*liste_carres[i].x)+scroll, liste_carres[i].y, liste_carres[i].w, liste_carres[i].w)
    love.graphics.rectangle("fill", (i*liste_carres[i].x)+scroll+largeur, liste_carres[i].y, liste_carres[i].w, liste_carres[i].w)
  end
  love.graphics.setColor(0, 0, 1)
  love.graphics.line(largeur+scroll, 0, largeur+scroll, hauteur)
  love.graphics.setColor(1, 1, 1)
  
  love.graphics.print(scroll, 10, 10)
end

--[[_______________________________________________________________________________________________________________________
___________________________________________________________________________________________________________________________
]]

    -- Effet d'effecement et de réapparition d'une image.
    
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")

function love.load()
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  
  logo = {}
  logo.img = love.graphics.newImage("ul_paper.jpg")
  logo.img_w = logo.img:getWidth()
  logo.img_h = logo.img:getHeight()
  logo.x = largeur/2
  logo.y = hauteur/2
  logo.ox = logo.img_w/2
  logo.oy = logo.img_h/2
  
  splash_alpha = 1
  splash_alpha_vitesse = 1
  splash_alpha_pause = 2
  
  splash_state = {"vers_image", "pause", "vers_noir"}
  current_state = "vers_image"
end

function love.update(dt)
  if current_state == "vers_image" then
    splash_alpha = splash_alpha - (dt/4 * splash_alpha_vitesse)
    if splash_alpha <= 0 then
      current_state = "pause"
    end
  elseif current_state == "pause" then
    splash_alpha_pause = splash_alpha_pause - dt
    if splash_alpha_pause <= 0 then
      current_state = "vers_noir"
    end
  elseif current_state == "vers_noir" then
    splash_alpha_vitesse = -1
    splash_alpha = splash_alpha - (dt/4 * splash_alpha_vitesse)
    if splash_alpha >= 1 then
      splash_alpha = 1
    end
  end
end

function love.draw()
  love.graphics.draw(logo.img, logo.x, logo.y, 0, 1, 1, logo.ox, logo.oy)
  
  love.graphics.setColor(0, 0, 0, splash_alpha)
  love.graphics.rectangle("fill", 1, 1, largeur, hauteur)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print(splash_alpha, 10, 10)
  love.graphics.print(splash_alpha_pause, 10, 20)
end


-- Indique les coordonnées d'un point près de celui-ci.
function Indique_Point(p, texte, offset_x, offset_y)
  love.graphics.print(texte..": "..tostring(math.floor(p.x))..", "..tostring(math.floor(p.y)), p.x+offset_x, p.y+offset_y)
end

-- Affiche le contenu d'une variable à l'écran.
function Affiche_Variable(texte, v, x, y)
  love.graphics.print(texte..": "..tostring(v), x, y)
end

-- Petit objet qui affiche un cercle au pint d'intersection entre deux segments.
function Draw_Circle_On_Intersection_Point(p0, p1, p2, p3, ptable, segment_a, segment_b)
  local intersect = Line_Intersect(p0, p1, p2, p3, segment_a, segment_b)
  local click_point = {}
  local ghost = {}
  ghost.Update = function(dt)
    intersect = Line_Intersect(p0, p1, p2, p3, segment_a, segment_b)
    mouse_x, mouse_y = love.mouse.getPosition()
    if love.mouse.isDown(1) then
      click_point = Get_Clicked_Point(mouse_x, mouse_y, ptable)
      if click_point then
        click_point.x = mouse_x
        click_point.y = mouse_y
      end
    end
  end
  ghost.Draw = function(p_rayon)
    love.graphics.line(p0.x, p0.y, p1.x, p1.y)
    love.graphics.line(p2.x, p2.y, p3.x, p3.y)
    
    Draw_Points(p0, p_rayon)
    Draw_Points(p1, p_rayon)
    Draw_Points(p2, p_rayon)
    Draw_Points(p3, p_rayon)
    
    if intersect ~= false then
      love.graphics.circle("line", intersect.x, intersect.y, 15)
    end
  end
  return ghost
end

-- Objet qui premet de créer, de mettre à jour la position et d'afficher une étoile.
function Cree_Etoile(px, py, r, nb_points)
  local x = px
  local y = py
  local angle = 0
  local p = {}
  for i=1,nb_points do
    angle = (math.pi*2*i) / nb_points
    local t = {}
    if i%2 == 0 then
      t.x =  r * math.cos(angle)
      t.y =  r * math.sin(angle)
    else
      t.x =  (r/2) * math.cos(angle)
      t.y =  (r/2) * math.sin(angle)
    end
    table.insert(p, t)
  end
  local p_offset = {}
  for i=1,nb_points do
    local offset = {}
    offset.x = 0
    offset.y = 0
    table.insert(p_offset, offset)
  end
  local ghost = {}
  ghost.Update = function(dt, player)
    mouse_x, mouse_y = love.mouse.getPosition()
    if player then
      x = mouse_x
      y = mouse_y
    else
      x = px
      y = py
    end
    for i=1,#p do
      p_offset[i].x = p[i].x + x
      p_offset[i].y = p[i].y + y
    end
  end
  ghost.Draw = function()
    love.graphics.circle("fill", x, y, 5)
    for i=1,#p do
      love.graphics.circle("fill", p_offset[i].x, p_offset[i].y, 5)
      if i == #p then
        love.graphics.line(p_offset[i].x, p_offset[i].y, p_offset[1].x, p_offset[1].y)
      else
        love.graphics.line(p_offset[i].x, p_offset[i].y, p_offset[i+1].x, p_offset[i+1].y)
      end
    end
  end
  ghost.Points = function()
    return p_offset
  end
  return ghost
end

-----------------------------------------------------------------------------------------------------
-- demi point de vie

io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[arg] == "-debug" then require("mobdebug").start() end

function love.load()
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  
  PI = math.pi
  
  pv = 5
  
  chrono = 2
end

function love.update(dt)
  
end

function love.draw()
  a = math.abs(math.cos(love.timer.getTime() * chrono % 2 * math.pi))
  
  coeur_gauche = love.graphics.newCanvas(40, 30)
  coeur_droit = love.graphics.newCanvas(40, 30)
  
  love.graphics.setCanvas(coeur_gauche)
    love.graphics.arc("fill", "open", 20, 15, 10, PI/2, (3*PI)/2)
  love.graphics.setCanvas()
  
  love.graphics.setCanvas(coeur_droit)
    love.graphics.arc("fill", "open", 0, 15, 10, PI/2, -PI/2)
  love.graphics.setCanvas()
  
  
  for i=1, pv do
    if i%2 ~= 0 then
      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(coeur_gauche, i*20, 15)
      if pv == 1 then
        love.graphics.setColor(1, 1, 1, a)
      end
    else
      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(coeur_droit, i*20, 15)
    end
  end
end

function love.keypressed(key, scancode, isrepeat)
  if key == "up" then
    pv = pv + 1
  end
  
  if key == "down" then
    pv = pv - 1
  end
end