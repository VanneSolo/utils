entites = {}

function Create_Rect_Shape(pWorld, pos_x, pos_y, pType, pWidth, pHeight)
  rect_shape = {}
  rect_shape.body = love.physics.newBody(pWorld, pos_x, pos_y, pType)
  rect_shape.shape = love.physics.newRectangleShape(pWidth, pHeight)
  rect_shape.fixture = love.physics.newFixture(rect_shape.body, rect_shape.shape)
  table.insert(entites, rect_shape)
  return rect_shape
end

function Create_Circle_Shape(pWorld, pos_x, pos_y, pType, pRadius)
  circle_shape = {}
  circle_shape.body = love.physics.newBody(pWorld, pos_x, pos_y, pType)
  circle_shape.shape = love.physics.newCircleShape(pRadius)
  circle_shape.fixture = love.physics.newFixture(circle_shape.body, circle_shape.shape)
  table.insert(entites, circle_shape)
  return circle_shape
end

function Create_Edge_Shape(pWorld, pos_x, pos_y, pType, x1, y1, x2, y2)
  edge_shape = {}
  edge_shape.body = love.physics.newBody(pWorld, pos_x, pos_y, pType)
  edge_shape.shape = love.physics.newEdgeShape(x1, y1, x2, y2)
  edge_shape.fixture = love.physics.newFixture(edge_shape.body, edge_shape.shape)
  table.insert(entites, edge_shape)
  return edge_shape
end

function Create_Polygon_Shape(pWorld, pos_x, pos_y, pType, x1, y1, x2, y2, x3, y3, ...)
  verticies = {x1, y1, x2, y2, x3, y3, ...}
  verticies_2 = {}
  verticies_3 = {}
  if type(x1) == "table" then
    print(type(x1[i]))
    for i=1,#x1 do
      if type(x1[i]) == "table" then
        for j=1,#x1[i] do
          table.insert(verticies_2, x1[i][j])
        end
      else
        table.insert(verticies_3, x1[i])
      end
    end
  end
  polygon_shape = {}
  polygon_shape.body = love.physics.newBody(pWorld, pos_x, pos_y, pType)
  if type(x1) == "table" then
    if type(x1[i]) == "table" then
      polygon_shape.shape = love.physics.newPolygonShape(verticies_2)
    else
      polygon_shape.shape = love.physics.newPolygonShape(verticies_3)
    end
  else
    polygon_shape.shape = love.physics.newPolygonShape(verticies)
  end
  polygon_shape.fixture = love.physics.newFixture(polygon_shape.body, polygon_shape.shape)
  table.insert(entites, polygon_shape)
  return polygon_shape
end

function Create_Regular_Polygon_Shape(pWorld, pos_x, pos_y, pType, pCote, pArc, pRadius)
  regular_polygon_vertices = {}
  for i=1,pCote do
    vertice = {}
    angle = -i/pCote * pArc * DEGTORAD
    sin_i = math.sin(angle)*pRadius
    cos_i = math.cos(angle)*pRadius
    vertice[i] = {sin_i, cos_i}
    table.insert(regular_polygon_vertices, vertice[i])
  end
  temp = {}
  if type(regular_polygon_vertices == "table") then
    for i=1,#regular_polygon_vertices do
      if type(regular_polygon_vertices[i]== "table") then
        for j=1,#regular_polygon_vertices[i] do
          table.insert(temp, regular_polygon_vertices[i][j])
        end
      end
    end
  end
  regular_polygon_shape = {}
  regular_polygon_shape.body = love.physics.newBody(pWorld, pos_x, pos_y, pType)
  regular_polygon_shape.shape = love.physics.newPolygonShape(temp)
  regular_polygon_shape.fixture = love.physics.newFixture(regular_polygon_shape.body, regular_polygon_shape.shape)
  table.insert(entites, regular_polygon_shape)
  return regular_polygon_shape
end

function Create_Arc_Shape(pWorld, pos_x, pos_y, pType, pCote, pArcAngle, pRadius)
  chain_vertices = {}
  chain_vertices[1] = {0, 0}
  for i=1,(pCote-1) do
    vertice = {}
    angle = -i/(pCote-2) * pArcAngle * DEGTORAD + (-2.5*math.pi/6)
    sin_i = math.sin(angle)*pRadius
    cos_i = math.cos(angle)*pRadius
    vertice[i] = {sin_i, cos_i}
    table.insert(chain_vertices, vertice[i])
  end
  temp = {}
  if type(chain_vertices == "table") then
    for i=1,#chain_vertices do
      if type(chain_vertices[i]== "table") then
        for j=1,#chain_vertices[i] do
          table.insert(temp, chain_vertices[i][j])
        end
      end
    end
  end
  chain_shape = {}
  chain_shape.body = love.physics.newBody(pWorld, pos_x, pos_y, pType)
  chain_shape.shape = love.physics.newPolygonShape(temp)
  chain_shape.fixture = love.physics.newFixture(chain_shape.body, chain_shape.shape)
  table.insert(entites, chain_shape)
  return chain_shape
end