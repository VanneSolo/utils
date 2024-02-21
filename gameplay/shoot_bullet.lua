io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[arg] == "-debug" then require("mobdebug").start() end

function Create_Bullet(pX, pY, pRadius, pSpeed)
    bullet = {}
    bullet.x = pX
    bullet.y = pY + 10
    bullet.radius = pRadius
    bullet.speed = pSpeed
    
    table.insert(liste_bullet, bullet)
end

function love.load()
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  
  arme = {}
  arme.x = 0
  arme.y = hauteur/2
  arme.width = 100
  arme.height = 20
  
  liste_bullet = {}
  
  cadence_timer = 0
  nombre_bullet = 0
  cadence_pause = 0
  
  liste_mode = {"unique", "automatique", "rafale", "hybride"}
  numero_mode = 1
  mode = "unique"
end

function love.update(dt)
  pret_a_tirer = false
  cadence_timer = cadence_timer + dt
  
  if cadence_pause > 0 then
    cadence_pause = cadence_pause - dt
    if cadence_pause < 0 then
      cadence_pause = 0
    end
  end
  
  if mode == "automatique" or mode == "rafale" or mode == "hybride" then
    if cadence_timer > 0.6 and mode == "automatique" then
      cadence_timer = 0
      pret_a_tirer = true
    elseif cadence_timer > 0.2 and mode == "rafale" then
      cadence_timer = 0
      pret_a_tirer = true
    elseif cadence_timer > 0.2 and cadence_pause == 0 and mode == "hybride" then
      cadence_timer = 0
      pret_a_tirer = true
    end
  end
  
  if love.keyboard.isDown("space") then
    if mode == "automatique" and pret_a_tirer == true then
      Create_Bullet(arme.x, arme.y, 10, 5)
    elseif mode == "rafale" and pret_a_tirer == true and nombre_bullet < 10 then
      Create_Bullet(arme.x, arme.y, 10, 5)
      nombre_bullet = nombre_bullet + 1
    elseif mode == "hybride" and pret_a_tirer == true then
      Create_Bullet(arme.x, arme.y, 10, 5)
      nombre_bullet = nombre_bullet + 1
      if nombre_bullet == 10 then
        cadence_pause = 0.5
        nombre_bullet = 0
      end
    end
  end
  
  for i=#liste_bullet, 1, -1 do
    local p = liste_bullet[i]
    p.x = p.x + p.speed
    if p.x > largeur+10 then
      table.remove(liste_bullet, i)
    end
  end
end

function love.draw()
  love.graphics.rectangle("fill", arme.x, arme.y, arme.width, arme.height)
  
  for k,v in pairs(liste_bullet) do
    love.graphics.circle("fill", v.x, v.y, v.radius, v.speed)
  end
  
  for i=1, #liste_bullet do
    love.graphics.print(#liste_bullet, 1, 1)
  end
  
  love.graphics.print(mode, 1, 15)
end

function love.keypressed(key)
  if key == "m" then
    numero_mode = numero_mode + 1
    if numero_mode > #liste_mode then
      numero_mode = 1
    end
    
    mode = liste_mode[numero_mode]
  end
  
  if key == "space" then
    if mode == "unique" then
      Create_Bullet(arme.x, arme.y, 10, 5)
    elseif mode == "automatique" or mode == "rafale" or mode == "hybride" then
      cadence_timer = 0
      nombre_bullet = 0
    end
  end
  
end