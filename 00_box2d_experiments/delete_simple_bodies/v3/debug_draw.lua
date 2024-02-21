require "physical_shape"
require "add_fixture"

function Draw_Edge(pEntite)
  love.graphics.line(pEntite.body:getWorldPoints(pEntite.shape:getPoints()))
end

function Draw_Rect_Or_Poly(pType, pEntite)
  love.graphics.polygon(pType, pEntite.body:getWorldPoints(pEntite.shape:getPoints()))
end

function Draw_Circle(pType, pEntite)
  love.graphics.circle(pType, pEntite.body:getX(), pEntite.body:getY(), pEntite.shape:getRadius())
end

function Draw_Supplemental_Edge(pBody, pShape)
  love.graphics.line(pBody.body:getWorldPoints(pShape.shape:getPoints()))
end

function Draw_Supplemental_Circle(pType, pBody, pShape)
  love.graphics.circle(pType, pBody.body:getX(), pBody.body:getY(), pShape.shape:getRadius())
end

function Draw_Supplemental_Rect_Or_Poly(pType, pBody, pShape)
  love.graphics.polygon(pType, pBody.body:getWorldPoints(pShape.shape:getPoints()))
end