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


function Add_Circle_Fixture(pBody, pRadius)
  loc_circle = {}
  loc_circle.shape = love.physics.newCircleShape(pRadius)
  loc_circle.fixture = love.physics.newFixture(pBody, loc_circle.shape)
  table.insert(new_fixture, loc_circle)
  return loc_circle
end


function Add_Polygon_Fixture()
  
end