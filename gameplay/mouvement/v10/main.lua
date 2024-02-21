largeur = 0
hauteur = 0

bord_haut = 0
bord_droit = 0
bord_bas = 0
bord_gauche = 0

decalage = 0

contour = {}
joueur = {}

norm = 0

function love.load()
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  
  decalage = 50
  
  bord_haut = decalage
  bord_droit = largeur-decalage
  bord_bas = hauteur-decalage
  bord_gauche = decalage
  
  contour = {}
  contour[1] = {x1 = bord_gauche, x2 = bord_droit, y = bord_haut}
  contour[2] = {x = bord_droit, y1 = bord_haut, y2 = bord_bas}
  contour[3] = {x1 = bord_gauche, x2 = bord_droit, y = bord_bas}
  contour[4] = {x = bord_gauche, y1 = bord_haut, y2 = bord_bas}
  
  joueur = {}
  joueur.w = 20
  joueur.h = 40
  joueur.x = largeur/2-joueur.w/2
  joueur.y = hauteur/2-joueur.h/2
  joueur.sens_x = 0
  joueur.sens_y = 0
  joueur.vitesse_x = 0
  joueur.vitesse_y = 0
  joueur.const_speed = 5
  joueur.frein = 0.9
end

function love.update(dt)
  if love.keyboard.isDown("up") then
    joueur.sens_y = joueur.sens_y - 1
    joueur.vitesse_y = joueur.const_speed
  end
  if love.keyboard.isDown("right") then
    joueur.sens_x = joueur.sens_x + 1
    joueur.vitesse_x = joueur.const_speed
  end
  if love.keyboard.isDown("down") then
    joueur.sens_y = joueur.sens_y + 1
    joueur.vitesse_y = joueur.const_speed
  end
  if love.keyboard.isDown("left") then
    joueur.sens_x = joueur.sens_x - 1
    joueur.vitesse_x = joueur.const_speed
  end
  
  norm = math.sqrt(joueur.sens_x^2 + joueur.sens_y^2)
  if norm ~= 0 then
    joueur.sens_x = joueur.sens_x / norm
    joueur.sens_y = joueur.sens_y / norm
    joueur.sens_x = joueur.sens_x * joueur.vitesse_x
    joueur.sens_y = joueur.sens_y * joueur.vitesse_y
  end
  joueur.x = joueur.x + joueur.sens_x
  joueur.y = joueur.y + joueur.sens_y
  joueur.vitesse_x = joueur.vitesse_x * joueur.frein
  joueur.vitesse_y = joueur.vitesse_y * joueur.frein
  if joueur.vitesse_x < 0.1 then
    joueur.vitesse_x = 0
  end
  if joueur.vitesse_y < 0.1 then
    joueur.vitesse_y = 0
  end
  
  if joueur.x >= bord_droit-joueur.w then
    joueur.x = bord_droit-joueur.w
    joueur.sens_x = 0
  end
  if joueur.x <= bord_gauche then
    joueur.x = bord_gauche
    joueur.sens_x = 0
  end
  if joueur.y >= bord_bas-joueur.h then
    joueur.y = bord_bas-joueur.h
    joueur.sens_y = 0
  end
  if joueur.y <= bord_haut then
    joueur.y = bord_haut
    joueur.sens_y = 0
  end
end

function love.draw()
  love.graphics.line(contour[1].x1, contour[1].y, contour[1].x2, contour[1].y)
  love.graphics.line(contour[2].x, contour[2].y1, contour[2].x, contour[2].y2)
  love.graphics.line(contour[3].x1, contour[3].y, contour[3].x2, contour[3].y)
  love.graphics.line(contour[4].x, contour[4].y1, contour[4].x, contour[4].y2)
  
  love.graphics.rectangle("fill", joueur.x, joueur.y, joueur.w, joueur.h)
end