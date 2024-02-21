io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

--[[
Variables globales:
* largeur et hauteur de l'écran
* tableau qui contiendra les informations à propos du héros
* chaînes de caractères qui contiennent le nom des zones et qui s'afficheront à l'écran
* images de fond
* compteur qui servira au défilement de la map
* variable qui servira à définir la position verticale du héros
* musiques et sons
* tableau qui contiendra l'objet qui va gérer les musiques
]]

local screenw
local screenh
local hero = {}
local zone1 = "CAMPAGNE"
local zone2 = "VILLE"
local imgBackground1 = love.graphics.newImage("paysage_chateau.png")
local imgBackground2 = love.graphics.newImage("paysage_urbain.png")
local backgroundX = 1
local groundPosition
local musicCampagne = love.audio.newSource("orgue_pourri_court.wav", "stream")
local musicVille = love.audio.newSource("techno_pourrie_court.wav", "stream")
local sndJump = love.audio.newSource("jump.wav", "static")
local sndLanding = love.audio.newSource("landing.wav", "static")
local musicManager = {}

--[[
Cette fonction simule un objet qui va gérer les musiques. On crée un tableau local (myMM) qui
contient dans un premier temps deux éléments: un autre tableau (listMusic) qui contiendra
toutes les musiques et une variable entière (currentMusic) qui servira à stocker l'ID de la musique en train d'être jouée.
Ensuite on crée trois fonctions dans le music manager, que l'on ajoute au tableau myMM :
* addMusic
* update
* playMusic

addMusic et playMusic sont appelées dans le load et update dans l'upate. 

addMusic possède un paramètre (pMusic). On crée un tableau (newMusic) qui contiendra les 
musiques. Ensuite on utilise la fonction "source" de Löve. On lui affecte la valeur de 
pMusic; par défaut on joue la musique en boucle et on règle le volume à 0. Enfin on ajoute le 
tableau newMusic dans le tableau listMusic. Quand on appelle la fonction dans le load, on 
passe la variable qui contient la musique en paramètre. Ainsi la musique se trouve placée 
dans le tableau newMusic puis dans le tableau listMusic.

La fonction update du music manager sert à régler le volume des musiques selon laquelle est 
en train d'être jouée. On parcours le tableau listMusic avec ipairs. Pour chaque "index" du 
tableau, on regarde s'il correspond à la musique actuellement jouée (currentMusic). Si oui 
mais que le son est inférieur à 1 alors on le monte progressivement, sinon et que le son est
supérieur à 0, alors on le mute progressivement aussi. C'est ce qui permet d'avoit un
changement de musique fluide.

playMusic possède un paramètre (pNum). On affecte à une variable locale (music) la valeur de
pNum passéee en index de listMusic. Ensuite, si le volume de la musique correspondant à cet
index est égal à 0 et que currentMusic est différent de cet index (pNum) alors on lance la 
musique correspondant à pNum. Enfin on attribue à currentMusic la valeur de pNum pour que
l'update puisse se mettre à jour.

Pour finin on renvoie le tableau myMM.
]]

function CreateMusicManager()
  local myMM = {}
  myMM.listMusic = {}
  myMM.currentMusic = 0
  
  function myMM.addMusic(pMusic)
    local newMusic = {}
    newMusic.source = pMusic
    newMusic.source:setLooping(true)
    newMusic.source:setVolume(0)
    table.insert(myMM.listMusic, newMusic)
  end
  
  function myMM.update()
    for index, music in ipairs(myMM.listMusic) do
      if index == myMM.currentMusic then
        if music.source:getVolume() < 1 then
          music.source:setVolume(music.source:getVolume() + 0.01)
        end  
      else
        if music.source:getVolume() > 0 then
          music.source:setVolume(music.source:getVolume() - 0.01)
        end
      end
    end
  end
  
  function myMM.playMusic(pNum)
    local music = myMM.listMusic[pNum]
    if music.source:getVolume() == 0 and myMM.currentMusic ~= pNum then
      print("Start music: "..pNum)
      music.source:play()
    end
    myMM.currentMusic = pNum
  end
  
  return myMM
end

--[[
Cette fonction permet de créer le héros. On défini un tableau (myHero) qui contient toutes
les informations de bases conceernant le personnage: sa position horizontale, sa position
verticale, sa vélocité verticale, le bolléen qui va permettre de contrôler le saut, un
tableau qui va contenir les images de l'animation du héros, le compteur qui indique à quelle
frame de l'animation on en est et enfin la largeur et la hauteur de l'image actuelle du perso.
Par défaut ces trois dernières variables sont initialisées à la première image.

Ensuite on utilise une boucle for qui va charger les images du héros. Pour cela il faut mettre
comme point de départ 1 (pour la première image) et comme itérateur la valeur de la dernière
image (ici 8). Pour que ça fonctionne, il faut que toutes les images aient le même nom avec
juste leur numéro de frame qui diffère. 
Dans le corps de la boucle on crée un variable locale qui va stocker une image de l'animation 
du héros et on stocke cette image dans listImage. L'opération se répète à chaque tour de 
boucle.

Pour finir on retourne le tableau qui contient toutes les infos du héros.
]]

function CreateHero()
  local myHero = {}
  myHero.x = 0
  myHero.y = 0
  myHero.vy = 0
  myHero.jump = false
  myHero.listImage = {}
  
  local n
  for n = 1, 8 do
    local myImg = love.graphics.newImage("green_roger_"..n..".png")
    table.insert(myHero.listImage, myImg)
  end
  
  myHero.currentImage = 1
  myHero.width = myHero.listImage[1]:getWidth()
  myHero.height = myHero.listImage[1]:getHeight()
  
  return myHero
end

--[[
Dans le load on commence par créer la fenêtre du jeu et par lui donner un titre. Dans un
deuxième temps on récupère la largeur et la hauteur de l'écran de jeu. Ensuite on crée le héros
et on défini sa position horizontale et sa position verticale. En dernier on crée le musique manager, on lui ajoute nos deux musiques et on lance la première.
]]

function love.load()
  love.window.setMode(800, 600)
  love.window.setTitle("Atelier sons et musiques")
  screenw = love.graphics.getWidth()
  screenh = love.graphics.getHeight()
  
  hero = CreateHero()
  hero.x = screenw / 4
  groundPosition = screenh - 150
  hero.y = groundPosition
  
  musicManager = CreateMusicManager()
  musicManager.addMusic(musicCampagne)
  musicManager.addMusic(musicVille)
  musicManager.playMusic(1)
end

--[[
Dans l'update on commence par s'occuper des déplacements horizontaux du personnage. 

Après on règle la vélocité verticale pour le plaquer au sol. 

Ensuite on s'occupe du saut, par le biais du booléen jump lié au héros. S'il est sur vrai et 
que la valeur de la position verticale du perso est supérieure à la variable qui défini la 
position au sol du héros, alors on cape la position du héros à la valeur de cette variable 
pour éviter les bugs de collisions. On remet le booléen à faux, on annule la vélocité 
verticale et on joue le son pour l'atterrissage. 

Si le boléen est à vrai mais que la position verticale du héros ne pose pas problème alors on 
ajoute un nombre positif à la vélocité verticale pour faire descendre le personnage.

A présent on change la musique selon que le perso soit dans la moitié gauche ou la moitié 
droite de l'écran. Pour cela on vérifie de quel côté est situé le perso et quelle musique est
jouée. Si le perso est dans la moitié gauche de l'écran et que la musique jouée n'est pas la
première, alors on lance la musique 1. Si le perso est dans la seconde moitié de l'écran et que
la musique jouée n'est pas la deuxième alors on lance la musique 2.

On met à jour le musicManager.update.

On crée un scrolling infini pour le fond. On prend la variable prévue pour le défilement du
background et on lui soustrait un coefficient (ici 120) multiplié par le dt. Si la valeur de la
variable devient inférieure à 0 moins la largeur de la première image de fond on reset la 
valeur de la variable du background à 1.

Pour finir on augmente progressivement la frame courante du héros en additionnant à
currentImage un coefficient (ici 12 pour que l'animation ne soit pas trop rapide) multiplié
par le dt. Si la valeur de currentImage devient supérieure au nombre d'images dans le
tableau listImage alors on revient à la frame 1.
]]

function love.update(dt)
  if love.keyboard.isDown("right") and hero.x < screenw then
    hero.x = hero.x + 2 * 60 * dt
  elseif love.keyboard.isDown("left") and hero.x > 0 then
    hero.x = hero.x - 2 * 60 * dt
  end
  
  hero.y = hero.y + hero.vy * dt
  
  if hero.jump == true and hero.y > groundPosition then
    hero.y = groundPosition
    hero.jump = false
    hero.vy = 0
    sndLanding:play()
  end
  
  if hero.jump then
    hero.vy = hero.vy + 600 * dt
  end
  
  if hero.x < screenw / 2 and musicManager.currentMusic ~= 1 then
    musicManager.playMusic(1)
  elseif hero.x >= screenw / 2 and musicManager.currentMusic ~= 2 then
    musicManager.playMusic(2)
  end
  
  musicManager.update()
  
  backgroundX = backgroundX - 120 * dt
  if backgroundX <= 0 - imgBackground1:getWidth() then
    backgroundX = 1
  end
  
  hero.currentImage = hero.currentImage + 12 * dt
  if hero.currentImage > #hero.listImage then
    hero.currentImage = 1
  end
end

--[[
On utilise push pour conserver en mémoire les données d'affichage. 

On crée un tableau local, d'abord vide. Ensuite on indique que si le héros se situe dans la
première moitié de l'écran alors ce tableau prend la valeur de la première image de fond et que
si le perso est dans la seconde moitié de l'écran alors le tableau prend la valeur de la 
seconde image de fond. Suite à cela on dessine le fond, en utilisant la valeur du tableau
précédent comme drawable, la variable du fond mouvant comme position horizontale et 1 en 
position verticale. Quand du noir apparait sur la droite de l'écran à cause du défilement de
l'image de fond, alors on dessine un nouveau fond en utilisant le même drawable mais en 
définissant sa position horizontale à la valeur de la variable de défilement du background plus
la largeur de l'image de fond en train de défiler.

Avant de dessiner le personnage, on récupère la valeur entière de currentImage qu'on place 
dans une variable locale. Ensuite on dessine le héros. Comme drawable on place la variable
locale précédemment créée en index de listImage. Ainsi à chaque update l'image va changer et
le perso va s'animer.

Ensuite on dessine la ligne rouge à l'endroit qui sert "d'interrupteur" pour changer de zone
et on écrit le nom de chaque zone.

Enfin on restaure les paramètres d'affichage.
]]

function love.draw()
  love.graphics.push()
  --love.graphics.scale(2, 2)
  local imgBackground = {}
  
  if hero.x > screenw / 2 then
    imgBackground = imgBackground2
  else
    imgBackground = imgBackground1
  end
  love.graphics.draw(imgBackground, backgroundX, 1)
  if backgroundX < 1 then
    love.graphics.draw(imgBackground, backgroundX + imgBackground1:getWidth(), 1)
  end
  
  local nImage = math.floor(hero.currentImage)
  love.graphics.draw(hero.listImage[nImage], hero.x - hero.width / 2, hero.y - hero.height / 2, 0, 2, 2)
  
  love.graphics.setColor(1, 0.4, 0.4)
  love.graphics.line(screenw / 2, 0, screenw / 2, screenh)
  love.graphics.setColor(1, 1, 1)
  love.graphics.print(zone1, screenw / 4, 10)
  love.graphics.print(zone2, (screenw / 4) * 3, 10)
  
  love.graphics.pop()
end

--[[
On déclenche le saut. Si on appuie sur la touche voulue (ici flèche du haut ou espace) et que
le boléen de contrôle du saut est sur faux, alors le boléen devient vrai, on règle la vélocité
verticale de sorte à faire décoller le perso et on joue le son du saut.
]]

function love.keypressed(key)
  if (key == "up" or key == "space" or key == " ") and hero.jump == false then
    hero.jump = true
    hero.vy = -400
    sndJump:play()
  end
end