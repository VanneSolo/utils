io.stdout:setvbuf('no')
if arg[arg] == "-debug" then require("mobdebug").start() end

largeur = love.graphics.getWidth()
hauteur = love.graphics.getHeight()
norm = 0

joueur = {}
joueur.w = 20
joueur.h = 40
joueur.x = largeur/2-joueur.w/2
joueur.y = hauteur/2-joueur.h/2
joueur.speed_x = 0
joueur.speed_y = 0

joueur.move = function(pVelocity, dt)
  joueur.speed_x = 0
  joueur.speed_y = 0
  if love.keyboard.isDown("up") then
    joueur.speed_y = -pVelocity
  end
  if love.keyboard.isDown("right") then
    joueur.speed_x = pVelocity
  end
  if love.keyboard.isDown("down") then
    joueur.speed_y = pVelocity
  end
  if love.keyboard.isDown("left") then
    joueur.speed_x = -pVelocity
  end
  norm = math.sqrt(joueur.speed_x^2 + joueur.speed_y^2)
  if norm ~= 0 then
    joueur.speed_x = joueur.speed_x / norm
    joueur.speed_y = joueur.speed_y / norm
    joueur.speed_x = joueur.speed_x * pVelocity
    joueur.speed_y = joueur.speed_y * pVelocity
  end
  joueur.x = joueur.x + joueur.speed_x * dt
  joueur.y = joueur.y + joueur.speed_y * dt
end

joueur.dessine = function()
  love.graphics.rectangle("fill", joueur.x, joueur.y, joueur.w, joueur.h)
end

function love.load()
  
end

function love.update(dt)
  joueur.move(200, dt)
end

function love.draw()
  joueur.dessine()
end