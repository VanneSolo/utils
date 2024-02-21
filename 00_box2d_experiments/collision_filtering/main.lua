if arg[#arg] =="-debug" then require("mobdebug").start() end

function love.load()
  -- Appel des fichiers qui contiennent le code pour dessiner les têtes.
  
  require "physical_shape"
  require "debug_draw"
  require "create_tete"
  
  -- Variables globales qui permettent de définir des paramètres généraux du programme.
  
  love.window.setMode(1250, 600)
  
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  largeur_drawzone = 800
  hauteur_drawzone = 600
  
  DEGTORAD = 0.0174532925199432957
  RADTODEG = 57.295779513082320876
  
  world = love.physics.newWorld(0, 10, true)
  world:setCallbacks(Begin_Contact, End_Contact, Pre_Solve, Post_Solve)
  
  text = ""
  persisting = 0
  love.physics.setMeter(25)
  metre = love.physics.getMeter()
  
  -- Création des bordures qui définissent la zone de jeu.
  
  bordures = {}
  bordures[1] = Create_Edge_Shape(world, largeur_drawzone/2, metre, "static", -metre*15, 0, metre*15, 0)
  bordures[2] = Create_Edge_Shape(world, largeur_drawzone-metre, hauteur_drawzone/2, "static", 0, -metre*11, 0, metre*11)
  bordures[3] = Create_Edge_Shape(world, largeur_drawzone/2, hauteur_drawzone-metre, "static", -metre*15, 0, metre*15, 0)
  bordures[4] = Create_Edge_Shape(world, metre, hauteur_drawzone/2, "static", 0, -metre*11, 0, metre*11)
  for i=1, 4 do
    bordures[i].fixture:setUserData("bordures")
  end
  
  -- Création des catégories d'enetité pour gérer les collisions.
  
  bordures_category = 1
  vaisseau_ami = 2
  vaisseau_hostile = 3
  avion_ami = 4
  avion_hostile = 5
  tour_radar = 6
  radar_sensor = 7
  autre = 8
  
  -- Création des masques qui permettent de gérer avec quels groupes chaque entité va intéragir.
  
  vaisseau_ami_mask = {tour_radar, radar_sensor}
  avion_hostile_mask = {avion_hostile}
  tour_radar_mask = {vaisseau_ami, radar_sensor}
  radar_sensor_mask = {bordures_category, radar_sensor}
  
  -- Nombre d'entités que l'on veut créer pour chaque type.
  
  nombre_petite_tete_rouge = 7  -- avion hostile
  nombre_tour_radar_verte = 2  -- tour radar
  nombre_grosse_tete_verte = 2  -- vaisseau ami
  
  -- Tableaux qui contiennent les constructeurs des objets "tête".
  
  petite_boule_rouge = {}  -- avion hostile
  petite_boule_verte = {}  -- tour radar
  grosse_boule_verte = {}  -- vaissea ami
  
  rotation_radar = 45 * DEGTORAD
  rotation_radar_2 = 90 * DEGTORAD
  
  -- Boucles dans lesquelles on appelle le constructeur de l'objet "tête" autant de fois que l'on veut.

  for i=1,nombre_petite_tete_rouge do
    lil_boule_rouge = Create_Tete()
    table.insert(petite_boule_rouge, lil_boule_rouge)
  end
  
  for i=1,nombre_tour_radar_verte do
    lil_boule_verte = Create_Tete()
    table.insert(petite_boule_verte, lil_boule_verte)
  end
  
  for i=1,nombre_grosse_tete_verte do
    big_boule_verte = Create_Tete()
    table.insert(grosse_boule_verte, big_boule_verte)
  end
  
  -- Boucles dans lesquelles on défini les paramètres de chaque type d'entités.
  
  for i=1,nombre_petite_tete_rouge do
    petite_boule_rouge[i].Load_Tete(math.random(metre*2.5, largeur_drawzone-(metre*2.5)), math.random(metre*2.5, hauteur_drawzone-(metre*2.5)), "dynamic", "mechant "..tostring(i), 0, metre, avion_hostile, avion_hostile_mask)
  end
  
  for i=1,nombre_tour_radar_verte do
    petite_boule_verte[i].Load_Tete(math.random(metre*2.5, largeur_drawzone-(metre*2.5)), math.random(metre*2.5, hauteur_drawzone-(metre*2.5)), "kinematic", "radar", rotation_radar,  metre, avion_ami, tour_radar_mask)
    petite_boule_verte[i].Add_Sensor(metre*2, "radar_sensor "..tostring(i), radar_sensor, radar_sensor_mask)
  end
  
  for i=1,nombre_grosse_tete_verte do
    grosse_boule_verte[i].Load_Tete(math.random(metre*2.5, largeur_drawzone-(metre*2.5)), math.random(metre*2.5, hauteur_drawzone-(metre*2.5)), "dynamic", "gentil", rotation_radar_2, metre*2, vaisseau_ami, vaisseau_ami_mask)
    grosse_boule_verte[i].Add_Sensor(metre*4, "gentil_sensor "..tostring(i), radar_sensor, radar_sensor_mask)
  end
end


function love.update(dt)
  
  world:update(dt)
  framerate = love.timer.getFPS()
  
  if string.len(text) > 768 then
    text = ""
  end
end


function love.draw()
  
  for i=1,4 do
    Draw_Edge(bordures[i])
  end
  
  -- Boucles qui permettent de dessiner les têtes.
  
  for i=1,nombre_petite_tete_rouge do
    petite_boule_rouge[i].Draw_Tete(1, 0, 0, 1, 0, 0)
  end
  
  for i=1,nombre_tour_radar_verte do
      petite_boule_verte[i].Draw_Tete(0, 1, 0, 1, 0, 1)
    petite_boule_verte[i].Draw_Sensor(0, 1, 1)
  end
  
  for i=1,nombre_grosse_tete_verte do
    grosse_boule_verte[i].Draw_Tete(0, 1, 0, 1, 0, 1)
    grosse_boule_verte[i].Draw_Sensor(1, 1, 0)
  end
  
  love.graphics.print(text, largeur_drawzone-(metre*0.5), metre)
  love.graphics.print("framerate: "..tostring(framerate), metre*1.5, metre*1.5)
end


function Begin_Contact(mechant, gentil, coll)
  
  x, y = coll:getNormal()
  text = text.."\n"..mechant:getUserData().." is colliding with "..gentil:getUserData().." with a normal vector of \n"..x..", "..y.."\n"
  
  if Get_Radar_And_Aircraft(mechant, gentil, coll) then
    mechant_id = mechant:getUserData()
    mechant_id_num = tonumber(Find_Pattern(mechant_id, "%d+"))
    
    gentil_id = gentil:getUserData()
    gentil_id_str = Find_Pattern(gentil_id, "%D+")
    if gentil_id_str == "radar_sensor " then
      radar_id_num = tonumber(Find_Pattern(gentil_id, "%d+"))
      petite_boule_verte[radar_id_num].Radar_Spot_Hostile(petite_boule_rouge[mechant_id_num])
    elseif gentil_id_str == "gentil_sensor " then
      sensor_id_num = tonumber(Find_Pattern(gentil_id, "%d+"))
      grosse_boule_verte[sensor_id_num].Radar_Spot_Hostile(petite_boule_rouge[mechant_id_num])
    end
  end
end


function End_Contact(mechant, gentil, coll)
  
  persisting = 0
  text = text.."\n"..mechant:getUserData().." is uncolliding with "..gentil:getUserData().."\n"
  
  if Get_Radar_And_Aircraft(mechant, gentil, coll) then
    mechant_id = mechant:getUserData()
    mechant_id_num = Find_Pattern(mechant_id, "%d+")
    
    gentil_id = gentil:getUserData()
    gentil_id_str = Find_Pattern(gentil_id, "%D+")
    if gentil_id_str == "radar_sensor " then
      radar_id_num = tonumber(Find_Pattern(gentil_id, "%d+"))
      petite_boule_verte[radar_id_num].Radar_Lost_Hostile(petite_boule_rouge[mechant_id_num])
    elseif gentil_id_str == "gentil_sensor " then
      sensor_id_num = tonumber(Find_Pattern(gentil_id, "%d+"))
      grosse_boule_verte[sensor_id_num].Radar_Lost_Hostile(petite_boule_rouge[mechant_id_num])
    end
  end
end


function Pre_Solve(mechant, gentil, coll)
  
  if persisting == 0 then
    text = text.."\n"..mechant:getUserData().." is touching "..gentil:getUserData().."\n"
  elseif persisting < 20 then
    text = text.." "..persisting
  end
  persisting = persisting + 1
end


function Post_Solve(mechant, gentil, coll, normal_impulse, tangent_impulse)
  
end


function Get_Radar_And_Aircraft(radar_entity, aircraft_entity, contact)
  
  fixture_a, fixture_b = contact:getFixtures()
  sensor_a = fixture_a:isSensor()
  sensor_b = fixture_b:isSensor()
  if sensor_a == sensor_b then
    return false
  end
  entite_a = fixture_a:getUserData()
  entite_b = fixture_b:getUserData()
  if sensor_a then
    radar_entity = entite_a
    aircraft_entity = entite_b
  else
    radar_entity = entite_b
    aircraft_entity = entite_a
  end
  return true
end

function Find_Pattern(chaine, pattern, start)
  return string.sub(chaine, string.find(chaine, pattern, start))
end