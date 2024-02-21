--[[

    Travail ici sur tout ce qtouche à la génération de map et de terrain.

]]

local Game = {}

Game.hero = require "hero"

Game.map = {}
Game.map.grid = {
            {8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8},
            {8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8},
            {8, 8, 8, 7, 7, 8, 7, 8, 7, 8, 8, 7, 7, 7, 8, 8, 7, 8, 7, 8, 8, 7, 7, 7, 8, 7, 8, 8, 7, 8, 8, 8},
            {8, 8, 8, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 8},
            {8, 8, 7, 7, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 7, 8, 8, 8},
            {8, 8, 7, 7, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 6, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 7, 7, 8, 8},
            {8, 8, 8, 7, 1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 6, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 1, 7, 8, 8, 8},
            {8, 8, 7, 7, 1, 2, 3, 3, 3, 3, 3, 3, 3, 6, 6, 6, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 1, 7, 8, 8, 8},
            {8, 8, 7, 7, 1, 2, 3, 3, 3, 3, 3, 3, 3, 6, 5, 5, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 1, 7, 7, 8, 8},
            {8, 8, 7, 7, 1, 2, 3, 3, 3, 3, 3, 3, 5, 5, 5, 5, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 1, 7, 7, 8, 8},
            {8, 8, 8, 7, 1, 2, 3, 3, 3, 3, 3, 3, 5, 5, 5, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 1, 7, 7, 8, 8},
            {8, 8, 7, 7, 1, 2, 3, 3, 3, 3, 3, 3, 3, 5, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 1, 7, 8, 8, 8},
            {8, 8, 8, 7, 1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 1, 7, 7, 8, 8},
            {8, 8, 8, 7, 1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 1, 7, 8, 8, 8},
            {8, 8, 8, 7, 1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 6, 6, 6, 3, 3, 3, 2, 1, 7, 8, 8, 8},
            {8, 8, 7, 7, 1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 6, 3, 5, 5, 2, 1, 7, 7, 8, 8},
            {8, 8, 8, 7, 1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 6, 6, 6, 5, 2, 1, 7, 8, 8, 8},
            {8, 8, 7, 7, 1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 5, 5, 6, 5, 2, 1, 7, 8, 8, 8},
            {8, 8, 7, 7, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 5, 5, 6, 4, 2, 1, 7, 7, 8, 8},
            {8, 8, 8, 7, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 6, 4, 1, 1, 7, 8, 8, 8},
            {8, 8, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 8},
            {8, 8, 8, 7, 7, 8, 7, 8, 7, 8, 8, 7, 7, 7, 8, 8, 7, 8, 7, 8, 8, 7, 7, 7, 8, 7, 8, 8, 7, 8, 8, 8},
            {8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8},
            {8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8}
            }
    
Game.map.MAP_WIDTH = 32
Game.map.MAP_HEIGHT = 24
Game.map.TILE_WIDTH = 25
Game.map.TILE_HEIGHT = 25  

Game.tilesheet = {}
Game.tileTextures = {}
Game.tiletypes = {}

function Game.map.isSolid(pID)
  local tileType = Game.tiletypes[pID]
  if tileType == "cactus" or tileType == "tree" or tileType == "deep_water" then
    return true
  else
    return false
  end
end

function Game.Load()
  Game.tilesheet = love.graphics.newImage("tilesheet.png")
  local nbColumns = Game.tilesheet:getWidth() / Game.map.TILE_WIDTH
  local nbLines = Game.tilesheet:getHeight() / Game.map.TILE_HEIGHT
  local id = 1
  
  Game.tileTextures[0] = nil
  for l = 1, nbLines do
    for c = 1, nbColumns do
      Game.tileTextures[id] = love.graphics.newQuad(
        (c-1)*Game.map.TILE_WIDTH, (l-1)*Game.map.TILE_HEIGHT, 
        Game.map.TILE_WIDTH, Game.map.TILE_HEIGHT, 
        Game.tilesheet:getWidth(), Game.tilesheet:getHeight()
        )
      id = id + 1
    end
  end
    
  Game.tiletypes[1] = "sand"
  Game.tiletypes[2] = "earth"
  Game.tiletypes[3] = "grass"
  Game.tiletypes[4] = "cactus"
  Game.tiletypes[5] = "tree"
  Game.tiletypes[6] = "river"
  Game.tiletypes[7] = "beach_water"
  Game.tiletypes[8] = "deep_water"
  
  Game.map.fogGrid = {}
  for l = 1, Game.map.MAP_HEIGHT do
    Game.map.fogGrid[l] = {}
    for c = 1, Game.map.MAP_WIDTH do
      Game.map.fogGrid[l][c] = 1
    end
  end
  Game.map.clearFog2(Game.hero.line, Game.hero.column)
end

function Game.Update(dt)
Game.hero.Update(Game.map, dt)
end

function Game.map.clearFog2(pLine, pCol)
  for l = 1, Game.map.MAP_HEIGHT do
    for c = 1, Game.map.MAP_WIDTH do
      if c>0 and c<=Game.map.MAP_WIDTH and l>0 and l<=Game.map.MAP_HEIGHT then
        local dist = math.dist(c, l, pCol, pLine)
        if dist < 7 then
          local alpha = dist/7
          if Game.map.fogGrid[l][c]>alpha then
            Game.map.fogGrid[l][c]=alpha
          end
        end
      end
    end
  end
end

function Game.Draw()
  for l = 1,Game.map.MAP_HEIGHT do
    for c = 1,Game.map.MAP_WIDTH do
      local id = Game.map.grid[l][c]
      local texQuad = Game.tileTextures[id]
      if texQuad ~= nil then
        local x = (c-1)*Game.map.TILE_WIDTH
        local y = (l-1)*Game.map.TILE_HEIGHT
        love.graphics.draw(Game.tilesheet, texQuad, x, y)
        if Game.map.fogGrid[l][c] > 0 then
          love.graphics.setColor(0, 0, 0, Game.map.fogGrid[l][c])
          love.graphics.rectangle("fill", x, y, Game.map.TILE_WIDTH, Game.map.TILE_HEIGHT)
          love.graphics.setColor(1, 1, 1)
        end
      end
    end
  end
  
  Game.hero.Draw(Game.map)
end

return Game


--------------------------------------------------------------------------

-- Crée une tuile carrée.
function Cree_Tuile(pI, pJ, pT_Size, pAlpha)
  local tuile = {}
  tuile.x = (pJ-1)*pT_Size
  tuile.y = (pI-1)*pT_Size
  tuile.alpha = pAlpha
  return tuile
end

-- Fonction qui permet de créer une grille de tuiles. On défini d'abord une
-- table vide. Pour chaque ligne, on crée une nouvelle table vide. Dans une
-- seconde boucle, pour chaque colonne, on crée une tuile.
function Tile_Map(pLignes, pColonne, pTile_Size)
  local map = {}
  for i=1,pLignes do
    local ligne = {}
    table.insert(map, ligne)
    for j=1,pColonne do
      local tile = Cree_Tuile(i, j, pTile_Size, love.math.random()-0.5)
      table.insert(map[i], tile)
    end
  end
  -- Affichage de la grille. On place la fonction dans une nouvelle table (ici m)
  -- que l'on retourne ensuite pour qu'elle soit accessible à partir de la variable
  -- qui aura servi à appeler la fonction Tile_Map.
  local m = {}
  m.Draw = function()
    for i=1,pLignes do
      for j=1,pColonne do
        love.graphics.setColor(1, 0, 0, map[i][j].alpha)
        love.graphics.rectangle("fill", map[i][j].x, map[i][j].y, pTile_Size, pTile_Size)
      end
    end
    love.graphics.setColor(1, 1, 1, 1)
  end
  return m
end

-------------------------------------------------------------------------------------

-- Crée une forme de terrain montagneux vue de profil. La fonction prend cinq paramètres:
-- Une table de nompbres qui seront ramenés à des valeurs entre 0 et la hauteur de l'écran.
-- Une longueur x et une longueur y pour définir sur quelle longueur et quelle hauteur le
-- terrain va être créer.
-- Un coefficient y pour éventuellement réduire l'échelle du terrain verticalement.
-- Un offset y pour décaler l'origine en y du terrain.
-- On commence par récupérer la plus grande et la plus petite des valeurs de la table dans
-- deux variables. Ensuite on crée deux tables (ici p et p2). La première contiendra les
-- fonctions qui permettront de dessiner le terrain. La seconde est remplie par une boucle 
-- qui pour chaque valeur de la table de départ crée une nouvelle table qui contient les valeurs
-- x et y de chaque point du terrain.
-- Pour obtenir la coordonnée x des points, on divise le range_x par le nombre d'éléments dans la
-- table puis on multiplie le résultat par le tour de boucle en cours. On soustrait 1 au nombre
-- d'éléments dans la table et à l'indice de tour de boucle en cours pour bien caler le terrain
-- sur les extrémités du range_x.
-- Pour la coordonnée y, on normalise chaque valeur sur la hauteur de l'écran. On multiplie cette 
-- valeur par range_y (ici la hauteur de l'écran) et on soustrait cette nouvelle valeur du range_y.
-- On peut diviser le range_y par un coefficient pour réduire léchelle verticale du terrain et 
-- ajouter un offset_y opur décaler l'affichage du terrain verticalement.
function Make_2D_Mountains(pTable, pRange_X, pRange_Y, pK_Range_Y, pOffset_Y)
  local mini = Table_Min_Value(pTable)
  local maxi = Table_Max_Value(pTable)
  local p = {}
  local p2 = {}
  for i=1,#pTable do
    sections = {}
    sections.norm_value = Norm_Number(pTable[i], mini, maxi)
    sections.x = (pRange_X/(#pTable-1))*(i-1)
    sections.y = ((pRange_Y/pK_Range_Y)-((pRange_Y/pK_Range_Y)*sections.norm_value)) + pOffset_Y
    table.insert(p2, sections)
  end
  -- Fonctions d'affichage du terrain. Pour dessiner les lignes et remplir le bas du terrain, on part
  -- du point qui correspond au tour de boucle en cour et on trace jusqu'au suivant. Il faut donc arrêter
  -- la boucle une itération avant le nombre d'élément dans la table pour éviter d'aller chercher un 
  -- point qui n'existe pas. Pour les polygones, il faut dessiner les points dans le sens des aiguilles
  -- montres pour qu'ils soient reliés à la suite.
  p.Draw_Lines = function()
    for i=1,#p2-1 do
      love.graphics.line(p2[i].x, p2[i].y, p2[i+1].x, p2[i+1].y)
    end
  end
  p.Draw_Points = function()
    for i=1,#p2 do
      love.graphics.setPointSize(3)
      love.graphics.setColor(1, 0, 0)
      love.graphics.points(p2[i].x, p2[i].y)
      love.graphics.setColor(1, 1, 1)
    end
  end
  p.Draw_Terrain = function(height)
    for i=1,#p2-1 do
      love.graphics.setColor(0, 1, 0)
      love.graphics.polygon("fill", p2[i].x, p2[i].y, p2[i+1].x, p2[i+1].y, p2[i+1].x, height, p2[i].x, height)
      love.graphics.setColor(1, 1, 1)
    end
  end
  
  return p
end

-- Dessine une grille à base de lignes et snappe un cercle sur
-- l'intersection la plus proche du cirseur.
function Snap_Cursor_On_Grid(px, py)
  local ghost = {}
  ghost.Update_Cursor_Pos = function()
    px, py = love.mouse.getPosition()
    x = Round_Nearest(px, grid_size)
    y = Round_Nearest(py, grid_size)
    return x, y
  end
  ghost.Draw_Grid_With_Lines = function(limite_boucle_1, limite_boucle_2, pas)
    for i=1, limite_boucle_1, pas do
      love.graphics.line(i, 0, i, limite_boucle_2)
    end
    for j=1, limite_boucle_2, pas do
      love.graphics.line(0, j, limite_boucle_1, j)
    end
  end
  return ghost
end

----------------------------------------------------------------------------------------------------------------------

io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[arg] == "-debug" then require("mobdebug").start() end

function love.load()
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  
  piece_echec = {}
  piece_echec_quad = {}
  
  function Create_Quad(pImgFile, pNbSprite)
    sprite = {}
    sprite.img = love.graphics.newImage(pImgFile)
    sprite.width, sprite.height = sprite.img:getDimensions()
    sprite.local_width = sprite.width/pNbSprite
    for i = 1, sprite.width, sprite.local_width do
      sprite.quad_morceau = love.graphics.newQuad(0+(i-1), 0, sprite.local_width, sprite.height, sprite.img:getDimensions())
      table.insert(piece_echec_quad, sprite.quad_morceau)
    end
    table.insert(piece_echec, sprite)
    return sprite
  end
  
  chess_piece = Create_Quad("piece_spritesheet.png", 6)
  
  longueur_du_cote = 65
  nombre_de_cases = 8
  cote_du_damier = longueur_du_cote*nombre_de_cases
  reste_vertical = (hauteur - cote_du_damier)/2
  reste_horizontal = (largeur - cote_du_damier)/2
  reste_cote = (longueur_du_cote-sprite.local_width)/2
  
  centrer_le_damier_vertical = (largeur/2) - (cote_du_damier/2)
  centrer_le_damier_horizontal = (hauteur/2) - (cote_du_damier/2)
  
  ligne_damier_vertical = 0
  ligne_damier_horizontal = 0
  
  ligne = 0
  colonne = 0
  
  balise_depart_vertical = hauteur - reste_vertical
  balise_fin_vertical = reste_vertical + longueur_du_cote
  pas_vertical = -longueur_du_cote
  
  balise_depart_horizontal = reste_horizontal
  balise_fin_horizontal = largeur - (reste_horizontal+longueur_du_cote)
  pas_horizontal = longueur_du_cote
  
  lettres = {"A","B","C","D","E","F","G","H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}
  
  ligne_cliquee = 0
  colonne_cliquee = 0
end

function love.update(dt)
  
end

function love.draw()  
  for n = balise_depart_vertical, balise_fin_vertical, pas_vertical do
    ligne_damier_vertical = (n-reste_vertical) / longueur_du_cote
    love.graphics.print(ligne_damier_vertical, (largeur/2)-(cote_du_damier/2)-40, hauteur-n+(longueur_du_cote/2))
  end
      
  for k = balise_depart_horizontal, balise_fin_horizontal, pas_horizontal do
    ligne_damier_horizontal = (k-reste_horizontal) / longueur_du_cote
    love.graphics.print(lettres[ligne_damier_horizontal+1], k+(longueur_du_cote/2), (hauteur/2)-(cote_du_damier/2)-20)
  end
  
  for i=1, cote_du_damier, longueur_du_cote do
    ligne = ((i-1) / longueur_du_cote)+1
    for j=1, cote_du_damier, longueur_du_cote do
      colonne = ((j-1) / longueur_du_cote)+1
      
      if (ligne%2 == 0 and colonne%2 == 0) or (ligne%2 == 1 and colonne%2 == 1) then
        love.graphics.setColor(0.75, 0, 0.12)
        love.graphics.rectangle("fill", i+centrer_le_damier_vertical, j+centrer_le_damier_horizontal, longueur_du_cote, longueur_du_cote)
      else
        love.graphics.setColor(0.08, 1, 0.52)
        love.graphics.rectangle("fill", i+centrer_le_damier_vertical, j+centrer_le_damier_horizontal, longueur_du_cote, longueur_du_cote)
      end
      
      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(chess_piece.img, piece_echec_quad[6], (reste_horizontal+(longueur_du_cote*4))+reste_cote, reste_vertical+reste_cote)
      love.graphics.draw(chess_piece.img, piece_echec_quad[5], (reste_horizontal+(longueur_du_cote*3))+reste_cote, reste_vertical+reste_cote)
      love.graphics.draw(chess_piece.img, piece_echec_quad[1], reste_horizontal+reste_cote, reste_vertical+reste_cote)
      love.graphics.draw(chess_piece.img, piece_echec_quad[1], (reste_horizontal+(longueur_du_cote*7))+reste_cote, reste_vertical+reste_cote)
      love.graphics.draw(chess_piece.img, piece_echec_quad[2], (reste_horizontal+longueur_du_cote)+reste_cote, reste_vertical+reste_cote)
      love.graphics.draw(chess_piece.img, piece_echec_quad[2], (reste_horizontal+(longueur_du_cote*6))+reste_cote, reste_vertical+reste_cote)
      love.graphics.draw(chess_piece.img, piece_echec_quad[4], (reste_horizontal+(longueur_du_cote*2))+reste_cote, reste_vertical+reste_cote)
      love.graphics.draw(chess_piece.img, piece_echec_quad[4], (reste_horizontal+(longueur_du_cote*5))+reste_cote, reste_vertical+reste_cote)
      
      for i=1, cote_du_damier, longueur_du_cote do
        love.graphics.draw(chess_piece.img, piece_echec_quad[3], (reste_horizontal+i)+reste_cote, (reste_vertical+longueur_du_cote)+reste_cote)
      end
      
      love.graphics.setColor(0, 0, 0)
      love.graphics.draw(chess_piece.img, piece_echec_quad[6], (reste_horizontal+(longueur_du_cote*4))+reste_cote, (reste_vertical+(longueur_du_cote*7))+reste_cote)
      love.graphics.draw(chess_piece.img, piece_echec_quad[5], (reste_horizontal+(longueur_du_cote*3))+reste_cote, (reste_vertical+(longueur_du_cote*7))+reste_cote)
      love.graphics.draw(chess_piece.img, piece_echec_quad[1], reste_horizontal+reste_cote, (reste_vertical+(longueur_du_cote*7))+reste_cote)
      love.graphics.draw(chess_piece.img, piece_echec_quad[1], (reste_horizontal+(longueur_du_cote*7))+reste_cote, (reste_vertical+(longueur_du_cote*7))+reste_cote)
      love.graphics.draw(chess_piece.img, piece_echec_quad[2], (reste_horizontal+(longueur_du_cote))+reste_cote, (reste_vertical+(longueur_du_cote*7))+reste_cote)
      love.graphics.draw(chess_piece.img, piece_echec_quad[2], (reste_horizontal+(longueur_du_cote*6))+reste_cote, (reste_vertical+(longueur_du_cote*7))+reste_cote)
      love.graphics.draw(chess_piece.img, piece_echec_quad[4], (reste_horizontal+(longueur_du_cote*2))+reste_cote, (reste_vertical+(longueur_du_cote*7))+reste_cote)
      love.graphics.draw(chess_piece.img, piece_echec_quad[4], (reste_horizontal+(longueur_du_cote*5))+reste_cote, (reste_vertical+(longueur_du_cote*7))+reste_cote)
      
      for i=1, cote_du_damier, longueur_du_cote do
        love.graphics.draw(chess_piece.img, piece_echec_quad[3], (reste_horizontal+i)+reste_cote, (reste_vertical+longueur_du_cote*6)+reste_cote)
      end
      
      love.graphics.setColor(1, 1, 1)
    end
  end
  
end

function love.mousepressed(x, y, button)
  if button == 1 then
    ligne_cliquee = math.floor(((cote_du_damier-y+reste_vertical)/longueur_du_cote)+1)
    colonne_cliquee = math.floor(((x-reste_horizontal)/longueur_du_cote)+1)
    
    if ligne_cliquee < 1 or ligne_cliquee > nombre_de_cases or colonne_cliquee < 1 or colonne_cliquee > nombre_de_cases then
      print("Vous avez cliqué en dehors du damier")
    else
      print("Vous avez cliqué sur la ligne "..tostring(ligne_cliquee).." et sur la colonne "..tostring(lettres[colonne_cliquee]))
    end
  end
end

---------------------------------------------------------------------------------------------

		-- stalagmites / stalagtites

io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[arg] == "-debug" then require("mobdebug").start() end

function love.load()
  
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  
  buildings = 12
  nombre_etage = {}
  hauteur_etage = 10
  
  for i=1, buildings do
    hauteur_building = love.math.random(1, 11)
    table.insert(nombre_etage, hauteur_building)
  end
  monter = hauteur + (#nombre_etage*hauteur_etage)
  descendre = -(#nombre_etage*hauteur_etage)
end

function love.update(dt)
  
  monter = monter - 2
  if monter <= hauteur-50 then
    monter = hauteur-50
  end
  
  descendre = descendre + 2
  if descendre >= 50 then
    descendre = 50
  end
  
end

function love.draw()
  
  for i=1, buildings do
      espace = largeur/buildings
      love.graphics.rectangle("line", ((i-1)*espace)+(espace/2), monter, 20, -nombre_etage[i]*hauteur_etage)
      love.graphics.rectangle("line", ((i-1)*espace)+(espace/2), descendre, 20, nombre_etage[i]*hauteur_etage)
      
      love.graphics.print(nombre_etage[i], ((i-1)*espace)+(espace/2), (monter-20-(nombre_etage[i]*hauteur_etage)))
      love.graphics.print(nombre_etage[i], ((i-1)*espace)+(espace/2), (descendre+20+(nombre_etage[i]*hauteur_etage)))
  end
  
  love.graphics.line(0, hauteur-49, largeur, hauteur-49)
  love.graphics.line(0, 49, largeur, 49)
  
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", 0, hauteur-48, largeur, hauteur-48)
  love.graphics.rectangle("fill", 0, 0, largeur, 48)
  love.graphics.setColor(1, 1, 1)
  
end

----------------------------------------------------------------------------------

	-- Générer des carrées dans une zone définie

io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[arg] == "-debug" then require("mobdebug").start() end

function CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

function Create_Rectangle(pNombre)
  compteur = 0
  
  while compteur ~= pNombre do
    valide = false
    nb_essai = 0
    essai_max = 500
    while valide == false do
      nb_essai = nb_essai+1
      if nb_essai > essai_max then
        print("Nombre maximum d'essais atteint!")
        break
      end
    
      rect = {}
      rect.x = love.math.random(0, largeur)
      rect.y = love.math.random(0, hauteur)
      rect.width = love.math.random(10, 100)
      rect.height = love.math.random(10, 100)
      rect.red = love.math.random()
      rect.green = love.math.random()
      rect.blue = love.math.random()
      
      valide = true
      
      if ((rect.x + rect.width) >= largeur) or ((rect.y + rect.height) >= hauteur) then
        valide = false
      end
      for k,v in pairs(liste_rectangle) do
        if CheckCollision(rect.x, rect.y, rect.width, rect.height, v.x, v.y, v.width, v.height) then
          valide = false
        end
      end
      if valide then
        table.insert(liste_rectangle, rect)
        compteur = compteur + 1
      end
    end
  end
  
end

function love.load()
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  
  red = love.math.random(0.1, 1)
  green = love.math.random(0.1, 1)
  blue = love.math.random(0.1, 1)
  
  nombre_rectangle = 100
  liste_rectangle = {}
  
  Create_Rectangle(nombre_rectangle)
end

function love.update(dt)
  curseur_x, curseur_y = love.mouse:getPosition()
  
  for k, v in pairs(liste_rectangle) do
    if curseur_x>v.x and curseur_x<v.x+v.width and curseur_y>v.y and curseur_y<v.y+v.height then
      --print("Vous avez survolé le rectangle: "..tostring(k))
    end
  end
end

function love.draw()
  
  for k,v in pairs(liste_rectangle) do
    love.graphics.setColor(v.red, v.green, v.blue)
    love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
  end
end

function love.mousepressed(x, y, button)
  if button == 1 then
    for k, v in pairs(liste_rectangle) do
      if x>=v.x and x<=v.x+v.width and y>=v.y and y<=v.y+v.height then
        print("Vous avez cliqué sur le rectangle: "..tostring(k))
      end
    end
  end
end