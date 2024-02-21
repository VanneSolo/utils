require "physical_shape"

new_fixture = {}

function Add_Rect_Fixture(pBody, w, h)
  loc_rect = {}
  loc_rect.shape = love.physics.newRectangleShape(w, h)
  loc_rect.fixture = love.physics.newFixture(pBody, loc_rect.shape)
  table.insert(new_fixture, loc_rect)
  return loc_rect
end


function Add_Edge_Fixture(pBody, x1, y1, x2, y2)
  loc_edge = {}
  loc_edge.shape = love.physics.newEdgeShape(x1, y1, x2, y2)
  loc_edge.fixture = love.physics.newFixture(pBody, loc_edge.shape)
  table.insert(new_fixture, loc_edge)
  return loc_edge
end


function Add_Circle_Fixture(pBody, pX, pY, pRadius)
  loc_circle = {}
  loc_circle.shape = love.physics.newCircleShape(pX, pY, pRadius)
  loc_circle.fixture = love.physics.newFixture(pBody, loc_circle.shape)
  table.insert(new_fixture, loc_circle)
  return loc_circle
end


function Add_Polygon_Fixture(pBody, x1, y1, x2, y2, x3, y3, ...)
  verticies = {x1, y1, x2, y2, x3, y3, ...}
  --print(x1[1])
  verticies_2 = {}
  if type(x1) == "table" then
    for i=1,#x1 do
      if type(x1[i]) == "table" then
        for j=1,#x1[i] do
          table.insert(verticies_2, x1[i][j])
        end
      end
    end
  end
  polygon_shape = {}
  --polygon_shape.body = love.physics.newBody(pWorld, pos_x, pos_y, pType)
  if type(x1) == "table" then
    polygon_shape.shape = love.physics.newPolygonShape(verticies_2)
  else
    polygon_shape.shape = love.physics.newPolygonShape(verticies)
  end
  polygon_shape.fixture = love.physics.newFixture(pBody, polygon_shape.shape)
  table.insert(entites, polygon_shape)
  return polygon_shape
end