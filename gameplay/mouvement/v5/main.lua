largeur = 0
hauteur = 0
bord_haut = 0
bord_droit = 0
bord_bas = 0
bord_gauche = 0

contour = {}
joueur = {}

function love.load()
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  
  bord_haut = 50
  bord_droit = largeur-50
  bord_bas = hauteur-50
  bord_gauche = 50
  
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
  joueur.max_speed = 5
  joueur.x_speed = 0
  joueur.y_speed = 0
  joueur.disp = 0.5
  joueur.frein = 0.95
end

function love.update(dt)
  if math.abs(joueur.x_speed) < joueur.max_speed then
    if love.keyboard.isDown("right") then
      joueur.x_speed = joueur.x_speed + joueur.disp
    end
    if love.keyboard.isDown("left") then
      joueur.x_speed = joueur.x_speed - joueur.disp
    end
  end
  if math.abs(joueur.y_speed) < joueur.max_speed then
    if love.keyboard.isDown("up") then
      joueur.y_speed = joueur.y_speed - joueur.disp
    end
    if love.keyboard.isDown("down") then
      joueur.y_speed = joueur.y_speed + joueur.disp
    end
  end
  
  joueur.x = joueur.x + joueur.x_speed
  joueur.y = joueur.y + joueur.y_speed
  joueur.x_speed = joueur.x_speed * joueur.frein
  joueur.y_speed = joueur.y_speed * joueur.frein
  if math.abs(joueur.x_speed) < 0.1 then
    joueur.x_speed = 0
  end
  if math.abs(joueur.y_speed) < 0.1 then
    joueur.y_speed = 0
  end
  
  if joueur.x >= bord_droit-joueur.w then
    joueur.x = bord_droit-joueur.w
    joueur.x_speed = 0
  end
  if joueur.x <= bord_gauche then
    joueur.x = bord_gauche
    joueur.x_speed = 0
  end
  if joueur.y >= bord_bas-joueur.h then
    joueur.y = bord_bas-joueur.h
    joueur.y_speed = 0
  end
  if joueur.y <= bord_haut then
    joueur.y = bord_haut
    joueur.y_speed = 0
  end
end

function love.draw()
  love.graphics.line(contour[1].x1, contour[1].y, contour[1].x2, contour[1].y)
  love.graphics.line(contour[2].x, contour[2].y1, contour[2].x, contour[2].y2)
  love.graphics.line(contour[3].x1, contour[3].y, contour[3].x2, contour[3].y)
  love.graphics.line(contour[4].x, contour[4].y1, contour[4].x, contour[4].y2)
  
  love.graphics.rectangle("fill", joueur.x, joueur.y, joueur.w, joueur.h)
end