function DistanceK(x1, y1, x2, y2, pk, pa, pb)
  return( math.abs( pa*(x2-x1))^pk + math.abs(pb*(y2-y1))^pk )^(1/pk)
end

function DistanceInfini(x1, y1, x2, y2, pa, pb)
  return math.max( math.abs(pa*(x2-x1)) + math.abs(pb*(y2-y1)) )
end

function Distance(x1, y1, x2, y2, pk, pa, pb)
  if pk > 0 then
    return DistanceK(x1, y1, x2, y2, pk, pa, pb)
  else
    return DistanceInfini(x1, y1, x2, y2, pa, pb)
  end
end

function DistanceSimple(p1, p2)
  dist_p1_p2 = math.abs(p1 - p2)
  return dist_p1_p2
end

function Milieu(x1, y1, x2, y2)
  xMid = (x2 + x1) / 2
  yMid = (y2 + y1) / 2
  return xMid, yMid
end