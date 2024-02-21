-- Fonction générale de tweening. tps_depart divisé par tps_fin donne la
-- dilatation horizontale. C donne la dilatation verticale, debut indique
-- le point de depart en y de la courbe et k indique à quelle puissance on
-- élève la dilatation horizontale. arrivee est le point d'arrivée de la
-- courbe.
function Tween_Power(k, tps_depart, tps_fin, debut, arrivee)
  local C = arrivee-debut
  return C*math.pow(tps_depart/tps_fin, k) + debut
ends

function Linear_Tween(t, b, c, d)
  return c*t /d + b
end

function Ease_In_Quad(t, b, c, d)
  return c*(t/d)*t + b
end

function Ease_Out_Quad(t, b, c, d)
  return -c*(t/d)*(t-2)+b
end

function Ease_In_And_Out_Quad(t, b, c, d)
  t = t/d*2
  if t < 1 then
    return c/2*t*t + b
  end
  if t >= 1 then
    t = t-1
    return -c/2 * (t*(t-2)-1) + b
  end
end


-- Applique un coef d'easing au déplacement d'un point.
function Ease_To(p_pos, p_target, p_ease)
  dx = p_target.x - p_pos.x
  dy = p_target.y - p_pos.y
  
  p_pos.x = p_pos.x + dx * p_ease
  p_pos.y = p_pos.y + dy * p_ease
  
  if math.abs(dx) < 0.1 and math.abs(dy) < 0.1 then
    dx, dy = 0, 0
    p_pos.x = p_target.x
    p_pos.y = p_target.y
    return false
  end
  return true
end

-- Fonction qui gère le tween.
function Tween(pEntity, p_Property, p_target, duration, easingFunc)
  local start = p_Property
  local change = p_target - start
  local start_time = love.timer.getTime()
  local ghost = {}
  local time = 0
  ghost.Update = function(dt)
    time = love.timer.getTime() - start_time
    if time < duration then
      p_Property = easingFunc(time, start, change, duration)
    else
      time = duration
      p_Property = easingFunc(time, start, change, duration)
    end
  end
  ghost.Draw = function(ptype)
    if ptype == "trans" then
      pEntity.trans = p_Property
    elseif ptype == "x" then
      pEntity.x = p_Property
    elseif ptype == "y" then
      pEntity.y = p_Property
    end
    
    love.graphics.setColor(1, 1, 1, pEntity.trans)
    love.graphics.circle("fill", pEntity.x, pEntity.y, 20)
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("time: "..tostring(time), 5, 5)
    love.graphics.print("duration: "..tostring(duration), 5, 5+16)
    love.graphics.print("start: "..tostring(start), 5, 5+16*2)
    love.graphics.print("change: "..tostring(change), 5, 5+16*3)
  end
  return ghost
end


require "math_sup"

function Tween_Power(k, tps_depart, tps_fin, debut, arrivee)
  local C = arrivee-debut
  return C*math.pow(tps_depart/tps_fin, k) + debut
end

-- distance * time / duration + valeur départ
-- t = (temps) temps, c'est en incrémentant cette variable qu'on anime le tweening.
-- b = (valeur_depart) valeur de départ
-- c = (longueur_tween) distance à parcourir
-- d = (duree) durée du mouvement

--[[ TWEENING LINEAIRE ]]
function Linear(temps, valeur_depart, longueur_tween, duree)
  return longueur_tween * temps / duree + valeur_depart
end
  
--[[ TWEENING QUADRATIQUE ]]

function In_Quad(temps, valeur_depart, longueur_tween, duree)
  temps = temps / duree
  return longueur_tween * math.pow(temps, 2) + valeur_depart
end

function Out_Quad(temps, valeur_depart, longueur_tween, duree)
  temps = temps / duree
  return -longueur_tween * temps * (temps-2) + valeur_depart
end

function In_Out_Quad(temps, valeur_depart, longueur_tween, duree)
  temps = temps / duree * 2
  if temps < 1 then
    return longueur_tween / 2 * math.pow(temps, 2) + valeur_depart
  else
    return -longueur_tween / 2 * ((t-1) * (t-3) - 1) + valeur_depart
  end
end

function Out_In_Quad(temps, valeur_depart, longueur_tween, duree)
  if temps < duree / 2 then
    return Out_Quad(temps*2, valeur_depart, longueur_tween/2, duree)
  else
    return In_Quad((temps*2)-duree, valeur_depart+longueur_tween/2, longueur_tween/2, duree)
  end
end

--[[ TWEENING CUBIQUE ]]

function In_Cubic(temps, valeur_depart, longueur_tween, duree)
  temps = temps / duree
  return longueur_tween * math.pow(temps, 3) + valeur_depart
end

function Out_Cubic(temps, valeur_depart, longueur_tween, duree)
  temps = temps / duree - 1
  return longueur_tween * (math.pow(temps, 3)+1) + valeur_depart
end

function In_Out_Cubic(temps, valeur_depart, longueur_tween, duree)
  temps = temps / duree * 2
  if temps < 1 then
    return longueur_tween / 2 * temps * temps * temps + valeur_depart
  else
    temps = temps - 2
    return longueur_tween / 2 * (temps * temps * temps + 2) + valeur_depart
  end
end

function Out_In_Cubic(temps, valeur_depart, longueur_tween, duree)
  if temps < duree / 2 then
    return Out_Cubic(temps*2, valeur_depart, longueur_tween/2, duree)
  else
    return In_Cubic((temps*2)-duree, valeur_depart+longueur_tween/2, longueur_tween/2, duree)
  end
end

--[[ TWEENING QUART ]]

function In_Quart(temps, valeur_depart, longueur_tween, duree)
  temps = temps / duree
  return longueur_tween * math.pow(temps, 4) + valeur_depart
end

function Out_Quart(temps, valeur_depart, longueur_tween, duree)
  temps = temps / duree - 1
  return -longueur_tween * (math.pow(temps, 4)-1) + valeur_depart
end

function In_Out_Quart(temps, valeur_depart, longueur_tween, duree)
  temps = temps / duree * 2
  if temps < 1 then
    return longueur_tween/2 * math.pow(temps, 4) + valeur_depart
  else
    temps = temps - 2
    return -longueur_tween/2 * (math.pow(temps, 4)-2) + valeur_depart
  end
end

function Out_In_Quart(temps, valeur_depart, longueur_tween, duree)
  if temps < duree / 2 then
    return Out_Quart(temps*2, valeur_depart, longueur_tween/2, duree)
  else
    return In_Quart((temps*2)-duree, valeur_depart+longueur_tween/2, longueur_tween/2, duree)
  end
end

--[[ TWEENING QUINT ]]

function In_Quint(temps, valeur_depart, longueur_tween, duree)
  temps = temps / duree
  return longueur_tween * math.pow(temps, 5) + valeur_depart
end

function Out_Quint(temps, valeur_depart, longueur_tween, duree)
  temps = temps / duree - 1
  return longueur_tween * (math.pow(temps, 5)+1) + valeur_depart
end

function In_Out_Quint(temps, valeur_depart, longueur_tween, duree)
  temps = temps / duree * 2
  if temps < 1 then
    return longueur_tween / 2 * math.pow(temps, 5) + valeur_depart
  else
    temps = temps - 2
	return longueur_tween / 2 * (math.pow(temps, 5)+2) + valeur_depart
  end
end

function Out_In_Quint(temps, valeur_depart, longueur_tween, duree)
  if temps < duree / 2 then
    return Out_Quint(temps*2, valeur_depart, longueur_tween/2, duree)
  else
    return In_Quint((temps*2)-duree, valeur_depart+longueur_tween/2, longueur_tween/2, duree)
  end
end

--[[ TWEENING SINUS ]]

function In_Sinus(temps, valeur_depart, longueur_tween, duree)
  return -longueur_tween * math.cos(temps / duree * (math.pi/2)) + longueur_tween + valeur_depart
end

function Out_Sinus(temps, valeur_depart, longueur_tween, duree)
  return longueur_tween * math.sin(temps / duree * (math.pi/2)) + valeur_depart
end

function In_Out_Sinus(temps, valeur_depart, longueur_tween, duree)
  return -longueur_tween / 2 * (math.cos(math.pi * temps / duree) - 1) + valeur_depart
end

function Out_In_Sinus(temps, valeur_depart, longueur_tween, duree)
  if temps < duree / 2 then
    return Out_Sinus(temps*2, valeur_depart, longueur_tween/2, duree)
  else
    return In_Sinus((temps*2)-duree, valeur_depart+longueur_tween/2, longueur_tween/2, duree)
  end
end

--[[ TWEENING EXPO ]]

function In_Expo(temps, valeur_depart, longueur_tween, duree)
  if temps == 0 then
    return valeur_depart
  else
    return c * math.pow(2, 10*(temps/duree-1)) + valeur_depart - longueur_tween*0.001
  end
end

function Out_Expo(temps, valeur_depart, longueur_tween, duree)
  if temps == duree then
    return valeur_depart + longueur_tween
  else
    return longueur_tween * 1.001 * (-math.pow(2, -10*temps/duree) + 1) + valeur_depart
  end
end

function In_Out_Expo(temps, valeur_depart, longueur_tween, duree)
  if temps == 0 then
    return valeur_depart
  end
  if temps == duree then
    return valeur_depart + longueur_tween
  end
  temps = temps / duree * 2
  if temps < 1 then
    return longueur_tween / 2 * math.pow(2, 10*(temps-1)) + valeur_depart - longueur_tween*0.0005
  else
    temps = temps - 1
	return longueur_tween / 2 * 1.0005 * (-math.pow(2, -10*temps) + 2) + valeur_depart
  end
end

function Out_In_Expo(temps, valeur_depart, longueur_tween, duree)
  if temps < duree / 2 then
    return Out_Expo(temps*2, valeur_depart longueur_tween/2, duree)
  else
    return In_Expo((temps*2)-duree, valeur_depart+longueur_tween/2, longueur_tween/2, duree)
  end
end

--[[ TWEENING CIRCULAIRE ]]

function In_Circ(temps, valeur_depart, longueur_tween, duree)
  temps = temps / duree
  return -longueur_tween * (math.sqrt(1 - math.pow(temps, 2)) - 1) + valeur_depart
end

function Out_Circ(temps, valeur_depart, longueur_tween, duree)
  temps = temps / duree - 1
  return longueur_tween * math.sqrt(1 - math.pow(temps, 2)) + valeur_depart
end

function In_Out_Circ(temps, valeur_depart, longueur_tween, duree)
  temps = temps / duree * 2
  if temps < 1 then
    return -longueur_tween / 2 * (math.sqrt(1 - temps * temps) - 1) + valeur_depart
  else
    temps = temps - 2
	return longueur_tween / 2 * (math.sqrt(1 - temps * temps) + 1) + valeur_depart
  end
end

function Out_In_Circ(temps, valeur_depart, longueur_tween, duree)
  if temps < duree / 2 then
    return Out_Circ(temps*2, valeur_depart, longueur_tween/2, duree)
  else
    return In_Circ((temps*2)-duree, valeur_depart+longueur_tween/2, longueur_tween/2, duree)
  end
end

--[[ TWEENING ELASTIQUE ]]

-- Il y a en plus deux paramètre "amplitude" et "période". Il faudra étudier ces paramètres
-- pour comprendre leur utilité.

--[[ TWEENING BACK ]]

-- Il y a en plus un paramètre "s". Il faudra étudier ce paramètre
-- pour comprendre son utilité.

--[[ TWEENING BOUNCE ]]

function In_Bounce(temps, valeur_depart, longueur_tween, duree)
  return longueur_tween - Out_Bounce(duree-temps, 0, longueur_tween, duree) + valeur_depart
end

function Out_Bounce(temps, valeur_depart, longueur_tween, duree)
  temps = temps / duree
  if temps < 1 / 2.75 then
    return longueur_tween * (7.5625 * temps * temps) + valeur_depart
  elseif temps < 2 / 2.75 then
    temps = temps - (1.5/2.75)
	return longueur_tween * (7.5625 * temps * temps + 0.75) + valeur_depart
  elseif temps < 2.5 / 2.75 then
    temps = temps - (2.25/2.75)
	return longueur_tween * (7.5625 * temps * temps + 0.9375) + valeur_depart
  else
    temps = temps - (2.625/2.75)
	return longueur_tween * (7.5625 * temps * temps + 0.984375) + valeur_depart
  end
end

function In_Out_Bounce(temps, valeur_depart, longueur_tween, duree)
  if temps < duree / 2 then
    return In_Bounce(temps*2, 0, longueur_tween, duree) + valeur_depart
  else
    return Out_Bounce(temps*2-duree, 0, longueur_tween, duree) * 0.5 + longueur_tween * 0.5 + b
  end
end

function Out_In_Bounce(temps, valeur_depart, longueur_tween, duree)
  if temps < duree / 2 then
    return Out_Bounce(temps*2, valeur_depart, longueur_tween/2, duree)
  else
    return In_Bounce((temps*2)-duree,  valeur_depart+longueur_tween/2, longueur_tween/2, duree)
  end
end