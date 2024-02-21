largeur = 0
hauteur = 0
bord_gauche = 0
bord_droit = 0

sol = {}
joueur = {}

function love.load()
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  bord_gauche = 0
  bord_droit = largeur
  
  sol = {}
  sol.x1 = 0
  sol.x2 = largeur
  sol.y = hauteur-50
  
  joueur = {}
  joueur.w = 20
  joueur.h = 40
  joueur.x = largeur/2
  joueur.y = sol.y-joueur.h
  joueur.vitesse_max = 5
  joueur.vitesse = 0
  joueur.disp = 0.5
  joueur.frein = 0.9
end

function love.update(dt)
  if math.abs(joueur.vitesse) < joueur.vitesse_max then
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
  end
  if joueur.x <= bord_gauche then
    joueur.x = bord_gauche
    joueur.vitesse = 0
  end
end

function love.draw()
  love.graphics.line(sol.x1, sol.y, sol.x2, sol.y)
  love.graphics.rectangle("fill", joueur.x, joueur.y, joueur.w, joueur.h)
end