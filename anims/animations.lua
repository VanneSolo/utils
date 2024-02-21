--[[

  Entasser ici tout ce qui ressemble à du code pour faire des animations. Dans un deuxième temps reprendre le code
  pour en faire une petite lib réutilisable.

]]

    -- 1ere partie d'un système d'animations qui sans spritesheet, avec les images séparées.
io.stdout:setvbuf('no')
if arg[arg] == "-debug" then require("mobdebug").start() end

function love.load()
  require "sprite"
  
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  
  barbare = Cree_Sprite()
  --img = love.graphics.newImage("v2_green_roger_1.png")
  --Set_Sprite(barbare, img)
  Ajoute_Image(barbare, "marche_1", love.graphics.newImage("v2_green_roger_1.png"))
  Ajoute_Image(barbare, "marche_2", love.graphics.newImage("v2_green_roger_2.png"))
  Ajoute_Image(barbare, "marche_3", love.graphics.newImage("v2_green_roger_3.png"))
  Ajoute_Image(barbare, "marche_4", love.graphics.newImage("v2_green_roger_4.png"))
  Ajoute_Image(barbare, "marche_5", love.graphics.newImage("v2_green_roger_5.png"))
  Ajoute_Image(barbare, "marche_6", love.graphics.newImage("v2_green_roger_6.png"))
  Ajoute_Image(barbare, "marche_7", love.graphics.newImage("v2_green_roger_7.png"))
  Ajoute_Image(barbare, "marche_8", love.graphics.newImage("v2_green_roger_8.png"))
  
  Ajoute_Animation(barbare, "Marche", {"marche_1", "marche_2", "marche_3", "marche_4", "marche_5", "marche_6", "marche_7", "marche_8"}, true)
  Start_Animation(barbare, "Marche")
  
  Ajoute_Image(barbare, "explosion_1", love.graphics.newImage("gros_boum_1.png"))
  Ajoute_Image(barbare, "explosion_2", love.graphics.newImage("gros_boum_2.png"))
  Ajoute_Image(barbare, "explosion_3", love.graphics.newImage("gros_boum_3.png"))
  Ajoute_Image(barbare, "explosion_4", love.graphics.newImage("gros_boum_4.png"))
  Ajoute_Image(barbare, "explosion_5", love.graphics.newImage("gros_boum_5.png"))
  
  Ajoute_Animation(barbare, "Explosion", {"explosion_1", "explosion_2", "explosion_3", "explosion_4", "explosion_5"}, false)
end

function love.update(dt)
  Update_Animation(barbare, dt)
  
  if love.keyboard.isDown("up") and barbare.current_animation == "Marche" then
    barbare.y = barbare.y - 2
  end
  if love.keyboard.isDown("right") and barbare.current_animation == "Marche" then
    barbare.x = barbare.x + 2
  end
  if love.keyboard.isDown("down") and barbare.current_animation == "Marche" then
    barbare.y = barbare.y + 2
  end
  if love.keyboard.isDown("left") and barbare.current_animation == "Marche" then
    barbare.x = barbare.x - 2
  end
  
  if barbare.current_animation == "Explosion" and barbare.animation_end["Explosion"] == true then
    Start_Animation(barbare, "Marche")
  end
end

function love.draw()
  love.graphics.setBackgroundColor(0.5, 0.5, 0.5)
  Draw_Sprite(barbare)
end

function love.keypressed(key)
  if key == "space" then
    Start_Animation(barbare, "Explosion")
  end
end

--[[_____________________________________________________________________________________________________________________________
_________________________________________________________________________________________________________________________________
]]

    --2eme partie du système d'animations avec des imamges séparées.
function Cree_Sprite()
  local sprite = {}
  sprite.images = {}
  sprite.image = nil
  sprite.x = 0
  sprite.y = 0
  sprite.animations = {}
  sprite.animation_loop = {}
  sprite.animation_end = {}
  sprite.current_animation = ""
  sprite.current_frame = 1
  sprite.timer_animation = 0
  return sprite
end

function Set_Sprite(pSprite, pImage)
  pSprite.image = pImage
end

function Ajoute_Image(pSprite, pNom, pImage)
  pSprite.images[pNom] = pImage
end

function Ajoute_Animation(pSprite, pNom, pListeImages, pLoop)
  pSprite.animations[pNom] = pListeImages
  pSprite.animation_loop[pNom] = pLoop
  pSprite.animation_end[pNom] = false
end

function Start_Animation(pSprite, pNom)
  if pSprite.current_animation ~= pNom then
    pSprite.current_animation = pNom
    pSprite.current_frame = 1
    pSprite.timer_animation = 0
    pSprite.animation_end[pSprite.current_animation] = false
  end
end

function Update_Animation(pSprite, dt)
  pSprite.timer_animation = pSprite.timer_animation + dt
  if pSprite.timer_animation > 0.1 then
    pSprite.current_frame = pSprite.current_frame + 1
    local nb_images_animation = #pSprite.animations[pSprite.current_animation]
    if pSprite.current_frame > nb_images_animation then
      if pSprite.animation_loop[pSprite.current_animation] == true then
        pSprite.current_frame = 1
      else
        pSprite.current_frame = nb_images_animation
        pSprite.animation_end[pSprite.current_animation] = true
      end
    end
    pSprite.timer_animation = 0
  end
end

function Draw_Sprite(pSprite)
  if pSprite.image ~= nil then
    love.graphics.draw(pSprite.image, pSprite.x, pSprite.y)
  else
    local current_anim = pSprite.current_animation
    local anim = pSprite.animations[current_anim]
    local nom_frame = anim[pSprite.current_frame]
    local image = pSprite.images[nom_frame]
    love.graphics.draw(image, pSprite.x, pSprite.y)
  end
end

--[[__________________________________________________________________________________________________________
______________________________________________________________________________________________________________
]]

  -- Sysyème qui permet de faire avancer un sprite en case par case de manière fluide.
io.stdout:setvbuf('no')
if arg[arg] == "-debug" then require("mobdebug").start() end

function love.load()
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  nb_lignes = 10
  nb_colonnes = 10
  tuile_w = 25
  tuile_h = 25
  
  map = {}
  map[1] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
  map[2] = {1, 0, 0, 0, 0, 0, 0, 0, 0, 1}
  map[3] = {1, 0, 1, 0, 0, 0, 0, 0, 0, 1}
  map[4] = {1, 0, 1, 0, 0, 0, 0, 0, 0, 1}
  map[5] = {1, 0, 1, 1, 1, 1, 1, 0, 0, 1}
  map[6] = {1, 0, 0, 0, 0, 0, 1, 0, 0, 1}
  map[7] = {1, 1, 1, 1, 1, 1, 1, 0, 0, 1}
  map[8] = {1, 0, 0, 0, 0, 0, 0, 0, 0, 1}
  map[9] = {1, 0, 0, 0, 0, 0, 0, 0, 0, 1}
  map[10] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
  
  joueur = {}
  joueur.colonne = 2
  joueur.ligne = 2
  joueur.x = (joueur.colonne-1) * tuile_w
  joueur.y = (joueur.ligne-1) * tuile_h
  joueur.move_to_ligne = 2
  joueur.move_to_colonne = 2
  joueur.move = false
  joueur.vitesse = 130
end

function love.update(dt)
  if joueur.move == false then
    Repositionne_Joueur()
    if love.keyboard.isDown("up") then
      joueur.move_to_ligne = joueur.move_to_ligne - 1
      joueur.move = true
    elseif love.keyboard.isDown("right") then
      joueur.move_to_colonne = joueur.move_to_colonne + 1
      joueur.move = true
    elseif love.keyboard.isDown("down") then
      joueur.move_to_ligne = joueur.move_to_ligne + 1
      joueur.move = true
    elseif love.keyboard.isDown("left") then
      joueur.move_to_colonne = joueur.move_to_colonne - 1
      joueur.move = true
    end
  end
  
  local case = map[joueur.move_to_ligne][joueur.move_to_colonne]
  if case ~= 0 then
    joueur.move_to_ligne = joueur.ligne
    joueur.move_to_colonne = joueur.colonne
    joueur.move = false
  end
  
  if joueur.move == true then
    if joueur.move_to_colonne > joueur.colonne then
      joueur.x = joueur.x + joueur.vitesse*dt
      if math.floor(joueur.x/tuile_w)+1 >= joueur.move_to_colonne then
        joueur.colonne = joueur.move_to_colonne
        joueur.move = false
      end
    elseif joueur.move_to_colonne < joueur.colonne then
      joueur.x = joueur.x - joueur.vitesse*dt
      if math.ceil(joueur.x/tuile_w)+1 <= joueur.move_to_colonne then
        joueur.colonne = joueur.move_to_colonne
        joueur.move = false
      end
    elseif joueur.move_to_ligne > joueur.ligne then
      joueur.y = joueur.y + joueur.vitesse*dt
      if math.floor(joueur.y/tuile_h)+1 >= joueur.move_to_ligne then
        joueur.ligne = joueur.move_to_ligne
        joueur.move = false
      end
    elseif joueur.move_to_ligne < joueur.ligne then
      joueur.y = joueur.y - joueur.vitesse*dt
      if math.ceil(joueur.y/tuile_h)+1 <= joueur.move_to_ligne then
        joueur.ligne = joueur.move_to_ligne
        joueur.move = false
      end
    end
  end
end

function love.draw()
  for l=1,nb_lignes do
    for c=1,nb_colonnes do
      if map[l][c] == 1 then
        love.graphics.setColor(0.75, 0.75, 0.75)
        love.graphics.rectangle("fill", (c-1)*tuile_w, (l-1)*tuile_h, tuile_w, tuile_h)
        love.graphics.setColor(1, 1, 1)
      elseif map[l][c] == 0 then
        love.graphics.setColor(0.95, 0.85, 0.15)
        love.graphics.rectangle("fill", (c-1)*tuile_w, (l-1)*tuile_h, tuile_w, tuile_h)
        love.graphics.setColor(1, 1, 1)
      end
    end
  end
  love.graphics.setColor(1, 0, 0)
  love.graphics.rectangle("fill", joueur.x, joueur.y, tuile_w, tuile_h)
  love.graphics.setColor(1, 1, 1)
  
  love.graphics.print("x: "..tostring(joueur.x), 5, tuile_h*10)
  love.graphics.print("y: "..tostring(joueur.y), 5, (tuile_h*10)+16)
  love.graphics.print("colonne: "..tostring(joueur.colonne), 5, (tuile_h*10)+(16*2))
  love.graphics.print("ligne: "..tostring(joueur.ligne), 5, (tuile_h*10)+(16*3))
  love.graphics.print("colonne vers: "..tostring(joueur.move_to_colonne), 5, (tuile_h*10)+(16*4))
  love.graphics.print("ligne vers: "..tostring(joueur.move_to_ligne), 5, (tuile_h*10)+(16*5))
  love.graphics.print("etat move: "..tostring(joueur.move), 5, (tuile_h*10)+(16*6))
end

function love.keypressed(key)
  
end

function love.mousepressed(x, y, button)
  
end

function Repositionne_Joueur()
  joueur.x = (joueur.colonne-1) * tuile_w
  joueur.y = (joueur.ligne-1) * tuile_h
end

--[[_____________________________________________________________________________________________________
_________________________________________________________________________________________________________
]]

    -- Sytème qui joue une anim depuis une spritesheet.
    
io.stdout:setvbuf('no')
if arg[arg] == "-debug" then require("mobdebug").start() end

function love.load()
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  
  hero = {}
  hero.img = love.graphics.newImage("v2_green_roger_spritesheet.png")
  hero.w = hero.img:getWidth()
  hero.qw = hero.w/8
  hero.h = hero.img:getHeight()
  hero.x = 50
  hero.y = hauteur/2
  
  timer_frame = 0
  frame = 1
  
  quad = {}
  for i=1,8 do
    local x = (i-1) * 14
    quad[i] = love.graphics.newQuad(x, 0, hero.qw, hero.h, hero.w, hero.h)
  end
end

function love.update(dt)
  timer_frame = timer_frame + dt
  if timer_frame > 0.1 then
    timer_frame = 0
    frame = frame + 1
    if frame > 8 then
      frame = 1
    end
  end
end

function love.draw()
  love.graphics.setBackgroundColor(0.5, 0.5 , 0.5)
  for i=1,#quad do
    love.graphics.draw(hero.img, quad[frame], hero.x, hero.y)
  end
end