require "physical_shape"

function Draw_Edge(pEntite)
  love.graphics.line(pEntite.body:getWorldPoints(pEntite.shape:getPoints()))
end

function Draw_Rect_Or_Poly(pType, pEntite)
  love.graphics.polygon(pType, pEntite.body:getWorldPoints(pEntite.shape:getPoints()))
end

function Draw_Circle(pType, pEntite)
  love.graphics.circle(pType, pEntite.body:getX(), pEntite.body:getY(), pEntite.shape:getRadius())
end