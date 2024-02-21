io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[arg] == "-debug" then require("mobdebug").start() end

function love.load()
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()

  require "physical_shape"
  require "add_fixture"
  require "debug_draw"
  
  DEGTORAD = 0.0174532925199432957
  RADTODEG = 57.295779513082320876

  world = love.physics.newWorld(0, 0, true)

  love.physics.setMeter(25)
  metre = love.physics.getMeter()
  contact = false
  
  bordures = {}
  bordures[1] = Create_Edge_Shape(world, largeur/2, metre, "static", -metre*15, 0, metre*15, 0)
  bordures[2] = Create_Edge_Shape(world, largeur-metre, hauteur/2, "static", 0, -metre*11, 0, metre*11)
  bordures[3] = Create_Edge_Shape(world, largeur/2, hauteur-metre, "static", -metre*15, 0, metre*15, 0)
  bordures[4] = Create_Edge_Shape(world, metre, hauteur/2, "static", 0, -metre*11, 0, metre*11)
  
  liste_carre = {}
  function Cree_Carre()
    local carre = {}
    carre.x = love.math.random(metre*3, largeur-(metre*3))
    carre.y = love.math.random(metre*3, hauteur-(metre*3))
    carre.w = metre
    carre.phy = Create_Rect_Shape(world, carre.x, carre.y, "dynamic", carre.w, carre.w)
    table.insert(liste_carre, carre)
  end
  for i=1,5 do
    Cree_Carre()
  end
  
  liste_rond = {}
  function Cree_Rond()
    local rond = {}
    rond.x = love.math.random(metre*3, largeur-(metre*3))
    rond.y = love.math.random(metre*3, hauteur-(metre*3))
    rond.w = metre
    rond.phy = Create_Circle_Shape(world, rond.x, rond.y, "dynamic", rond.w)
    table.insert(liste_rond, rond)
  end
  for i=1,5 do
    Cree_Rond()
  end
  
  ray_cast_angle = 0
  ray_cast_longueur = metre * 15
  ray_cast_max_fraction = 1
  closest_fraction = 1
  intersection_normal_x = 0
  intersection_normal_y = 0
  centre_x = largeur/2
  centre_y = hauteur/2
  corps = world:getBodies()
end

function love.update(dt)
  world:update(dt)
  
  closest_fraction = 1
  contact = false
  ray_cast_angle = ray_cast_angle + (360/20/60) * DEGTORAD
  p2_x = centre_x + ray_cast_longueur * math.cos(ray_cast_angle)
  p2_y = centre_y + ray_cast_longueur * math.sin(ray_cast_angle)
  
  liste_bodies = {}
  for i=1,#corps do
    table.insert(liste_bodies, corps[i])
    liste_fixtures = {}
    for j=1,#liste_bodies do
      table.insert(liste_fixtures, liste_bodies[j]:getFixtures())
      for k=1,#liste_fixtures do
        if liste_fixtures[j][k] ~= nil then
          output_x, output_y, output_fraction = liste_fixtures[j][k]:rayCast(centre_x, centre_y, p2_x, p2_y, ray_cast_max_fraction)
          if output_x~=nil and output_y~=nil and output_fraction~=nil then
            contact = true
            if output_fraction < closest_fraction then
              closest_fraction = output_fraction
              intersection_normal_x = output_x
              intersection_normal_y = output_y
            end
          end
        end
      end
    end
  end
  
  intersection_point_x = centre_x + closest_fraction * (p2_x - centre_x)
  intersection_point_y = centre_y + closest_fraction * (p2_y - centre_y)
  
  normal_end_x = intersection_point_x + (intersection_normal_x*metre)
  normal_end_y = intersection_point_y + (intersection_normal_y*metre)
end

function love.draw()
  for i=1,#bordures do
    Draw_Edge(bordures[i])
  end
  
  for i=1,#liste_carre do
    Draw_Rect_Or_Poly("line", liste_carre[i].phy)
  end
  
  for i=1,#liste_rond do
    Draw_Circle("line", liste_rond[i].phy)
  end
  love.graphics.line(centre_x, centre_y, intersection_point_x, intersection_point_y)
  if contact == true then
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", intersection_point_x, intersection_point_y, 2)
    love.graphics.setColor(0, 1, 0)
    love.graphics.line(intersection_point_x, intersection_point_y, normal_end_x, normal_end_y)
  end
  love.graphics.setColor(1, 1, 1)
end

function Draw_Reflected_Ray(x1, y1, x2, y2)
  
end