function Choregraphie(pChrono, pEntite)
  if pChrono <= 0 then
    pChrono = 0
  elseif pChrono <= 0.5 then
    Stop(pEntite)
  elseif pChrono <= 2 then
    Bas_Gauche(pEntite)
  elseif pChrono <= 2.5 then
    Stop(pEntite)
  elseif pChrono <= 3.5 then
    Haut(pEntite)
  elseif pChrono <= 4 then
    Stop(pEntite)
  end
end