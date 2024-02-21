-- Renvoie une table clonée. On passe une table en paramètre puis on renvoie une nouvelle
-- table créée localement dans laquelle on a copié un à un tous les éléments de la première
-- table.
function Copie_Table(pTable)
  local new_table = {}
  for i=1,#pTable do
    table.insert(new_table, pTable[i])
  end
  return new_table
end

-- Renvoie la plus petite ou la plus grande valeur d'un tableau. Dans chaque cas on copie
-- d'abord la table sur laquelle on veut travailler pour ne pas la modifier. Ensuite on trie
-- la table dans l'ordre croissant. Pour récupérer le plus petit élément on retourne la
-- première valeur de la table copiée, pour récupérer le plus grand élément on retourne la
-- dernière valeur de la table copiée.
function Table_Min_Value(pTable)
  local copie = Copie_Table(pTable)
  table.sort(copie)
  local minimum = copie[1]
  return minimum
end

function Table_Max_Value(pTable)
  local copie = Copie_Table(pTable)
  table.sort(copie)
  local maximum = copie[#copie]
  return maximum
end

-- Algorithme de tri à bulles.
function Bubble_Sort(p_array)
  loop = #p_array
  for i=1,loop-1 do
    for j=1,loop-1 do
      if p_array[j] > p_array[j+1] then
        p_array[j], p_array[j+1] = Swap(p_array[j], p_array[j+1])
      end
    end
  end
  wesh = {}
  wesh.affiche = function()
    for i=1, loop do
      print(p_array[i])
    end
  end
  return wesh
end

--Crée un point avec ses coordonnées x et y.
function Point(x1, y1)
  local table = {}
  table.x = x1
  table.y = y1
  return table
end

-- Prend des points en entrée et renvoie une table avec les coordonnées
-- de tous les points à la suite.
function Include_Points_In_Table(p1, p2, p3, ...)
  local liste_acceuil = {p1, p2, p3, ...}
  local liste_retour = {}
  for i=1,#liste_acceuil do
    table.insert(liste_retour, liste_acceuil[i].x)
    table.insert(liste_retour, liste_acceuil[i].y)
  end
  return liste_retour
end

function Create_1D_Table(p_table)
  local new_tab = {}
  for i=1,#p_table do
    table.insert(new_tab, p_table[i].x)
    table.insert(new_tab, p_table[i].y)
  end
  return new_tab
end