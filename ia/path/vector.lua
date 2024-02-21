function NewVector(pX, pY)
  v = {}
  v.x = pX
  v.y = pY
  
  VectorMT = {}
  
  function VectorMT.__add(v1, v2)
    local somme = NewVector(0, 0)
    somme.x = v1.x + v2.x
    somme.y = v1.y + v2.y
    return somme
  end
  
  function VectorMT.__sub(v1, v2)
    local diff = NewVector(0, 0)
    diff.x = v1.x - v2.x
    diff.y = v1.y - v2.y
    return diff
  end
  
  function VectorMT.__mul(k, v)
    local prod = NewVector(0, 0)
    prod.x = k * v.x
    prod.y = k * v.y
    return prod
  end
  
  function VectorMT.__unm(v)
    local opp = NewVector(-v.x, -v.y)
    return opp
  end
  
  setmetatable(v, VectorMT)
  
  function v.norm()
    return math.sqrt(v.x^2 + v.y^2)
  end
  
  function v.normalize()
    local N = v.norm()
    v.x = v.x / N
    v.y = v.y / N
  end
  
  return v
end

function AddVectors(ax, ay, bx, by, cx, cy)
    point_origine = NewVector(ax, ay)
    
    dist_h_vec_1 = DistanceSimple(ax, bx)
    dist_v_vec_1 = DistanceSimple(ay, by)
    dist_h_vec_2 = DistanceSimple(cx, bx)
    dist_v_vec_2 = DistanceSimple(cy, by)
    
    if bx<ax then
      dist_h_vec_1 = - dist_h_vec_1
    end
    if by<ay then
      dist_v_vec_1 = - dist_v_vec_1
    end
    if cx<bx then
      dist_h_vec_2 = - dist_h_vec_2
    end
    if cy<by then
      dist_v_vec_2 = - dist_v_vec_2
    end
    
    long_h_vect_1_2 = dist_h_vec_1 + dist_h_vec_2
    long_v_vect_1_2 = dist_v_vec_1 + dist_v_vec_2
    
    vect_a_c = NewVector(long_h_vect_1_2, long_v_vect_1_2)
    
    vect_final = NewVector(point_origine.x + vect_a_c.x, point_origine.y + vect_a_c.y)
    return vect_final
end