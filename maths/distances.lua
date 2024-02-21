-- Fonction qui calcul le point milieu de deux points.
function Milieu(x1, y1, x2, y2)
  local xI = (x1+x2)/2
  local yI = (y1+y2)/2
  return xI, yI
end

-- Fonction qui renvoie la distance entre deux points.
function Distance(x1, y1, x2, y2)
  return math.sqrt((x2-x1)^2 + (y2-y1)^2)
end

function Dist_Vectors(vec1, vec2)
  dx = vec2.x - vec1.x
  dy = vec2.y - vec1.y
  return math.sqrt(dx^2 + dy^2)
end

-- Fonction qui renvoie la somme des deux côtés de l'angle droit.
function Dist_Manhattan(x1, y1, x2, y2)
  return math.abs(x2-x1) + math.abs(y2-y1)
end

-- Fonction Distance améliorée, avec des coefficients modifiables.
-- pour obtenir divers types de disances. a et b sont des coefficient
-- de déformation pour respectivement les longueurs en x et en y. k est
-- la puissance à laquelle on veut élever la distance.
function Dist_K(x1, y1, x2, y2, a, b, k)
  return ((a^k)*math.abs(x2-x1)^k + (b^k)*math.abs(y2-y1)^k) ^ (1/k)
end

-- Fonction qui calcule la distance quand k tend vers l'infini.
function Dist_Infinie(x1, y1, x2, y2, a, b)
  return math.max(a*math.abs(x2-x1), b*math.abs(y2-y1))
end