io.stdout:setvbuf('no')
if arg[arg] == "-debug" then require("mobdebug").start() end
love.graphics.setDefaultFilter("nearest")

--[[
  Inertie.
  
  * On donne une vitesse et une vitesse max à l'entité que l'on veut déplacer.
  * Durant le cotrôle des touches dans l'update, on ajoute une valeur à la vitesse
  sur l'axe x ou y de l'entité que l'on soughaite déplacer. On ajoute enfin cette 
  vitesse à la position, après le contrôle des touches, pour effectivement mettre à 
  jour la position de l'entité.
  * Pour caper la vitesse, on crée une condition qui compare la valeur absolue de la 
  vitesse avec la vitesse max et on place le contrôle des touches dedans.
  * Pour appliquer une friction à l'entité, après avoir ajouté la vitesse à la position,
  on multiplie la vitesse par une valeur inférieure à 1.
]]

largeur = nil
hauteur = nil

bord_gauche = nil
bord_droit = nil

joueur = {}
sol = {}

function love.load()
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  
  bord_gauche = 0
  bord_droit = largeur
  
  sol = {}
  sol.x1 = 0
  sol.y1 = hauteur-50
  sol.x2 = largeur
  sol.y2 = hauteur-50
  
  joueur = {}
  joueur.w = 20
  joueur.h = 40
  joueur.x = largeur/2
  joueur.y = (hauteur-50) - joueur.h
  joueur.vitesse_max = 5
  joueur.vitesse = 0
  joueur.disp = 0.4
  joueur.frein = 0.95
end

function love.update(dt)
  if math.abs(joueur.vitesse) <= joueur.vitesse_max then
    if love.keyboard.isDown("right") then
      joueur.vitesse = joueur.vitesse + joueur.disp
    end
    if love.keyboard.isDown("left") then
      joueur.vitesse = joueur.vitesse - joueur.disp
    end
  end
  
  joueur.x = joueur.x + joueur.vitesse
  joueur.vitesse = joueur.vitesse * joueur.frein
  if math.abs(joueur.vitesse) < 0.1 then
    joueur.vitesse = 0
  end
  
  if joueur.x >= bord_droit-joueur.w then
    joueur.x = bord_droit-joueur.w
    joueur.vitesse = 0
  elseif joueur.x <= bord_gauche then
    joueur.x = bord_gauche
    joueur.vitesse = 0
  end
end

function love.draw()
  love.graphics.setColor(0.82, 0.12, 0.27)
  love.graphics.line(sol.x1, sol.y1, sol.x2, sol.y2)
  love.graphics.setColor(1, 1, 1)
  
  love.graphics.rectangle("line", joueur.x, joueur.y, joueur.w, joueur.h)
  
  love.graphics.print("bord gauche: "..tostring(bord_gauche)..", joueur.x: "..tostring(math.floor(joueur.x))..", bord droit: "..tostring(bord_droit-joueur.w), 10,10)
  love.graphics.print("joueur.vitesse: "..tostring(joueur.vitesse), 10, 10+16)
end

function love.keypressed(key)
end