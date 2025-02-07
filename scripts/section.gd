##Le coeur du programme
class_name Section extends Resource

@export var sec: String = ""
@export var eleves: Array[Eleve] = []
@export var tables_vierges: Array[Table] = []
@export var taille_table: Vector2 = Vector2(128, 96)

## définir le nom de la classe, devrait déjà avoir été chécké pour format adapté à une sauvegarde
func set_nom_section(nom: String) -> void:
	sec = nom
	set_titre_fenetre()

## mise à jour du titre de la fenetre selon le nom de la classe
func set_titre_fenetre() -> void:
	DisplayServer.window_set_title(tr("TITRE") + " : %s" % sec)

## récupérer le nom de la classe	
func get_nom_section() -> String:
	return sec

## Obtenir le nombre d'élèves
func get_nb_eleves() -> int:
	return eleves.size()

## Ajouter un élève (class Eleve) à la section	
func ajouter_eleve(nom: String) -> bool:
	if get_nb_eleves() > 42: return false # arbitraire
	if eleves.any(func(e): return e.nom == nom): return false
	var nouveau: Eleve = Eleve.new()
	nouveau.nom = nom
	nouveau.table.pos = _nouvelle_position(get_nb_eleves())
	eleves.append(nouveau)
	return true
	
func _nouvelle_position(indice: int) -> Vector2:
	var nouvelle: Vector2 = taille_table * 2
	nouvelle.x += indice % 7 * taille_table.x # Crée une grille de 7 tables de long
	nouvelle.y += indice / 7 * taille_table.y
	return nouvelle

## Enlève un élève et toute trace des affinités pour lui des autres élèves
func enlever_dernier_eleve() -> bool:
	if eleves.is_empty():
		return false
	var nom_dernier: String = eleves.pop_back().nom
	for i in get_nb_eleves():
		if positif_existe(i, nom_dernier): enlever_positif(i, nom_dernier)
		if negatif_existe(i, nom_dernier): enlever_negatif(i, nom_dernier)
	return true

## Enlève tous les élèves (class Eleve) de Section.eleves 
func enlever_tous_eleves() -> void:
	eleves.clear()

## Obtenir le nom d'un élève	
func get_nom_eleve(indice: int) -> String:
	if indice < 0 or indice >= get_nb_eleves():
		return ""
	return eleves[indice].nom

## Obtenir l'indice d'un élève
func trouver_indice_eleve(nom: String) -> int:
	for i in get_nb_eleves():
		if eleves[i].nom == nom:
			return i
	return -1

## obtenir la liste des eleves
func liste_eleves() -> Array:
	return eleves.map(func(e): return e.nom)

## tri selon l'alphabet des élèves (true) ou inversé (false)
func tri_alphabet(az: bool = true) -> bool:
	if get_nb_eleves() < 2: return false
	if az: 
		eleves.sort_custom(func(a,b): return a.nom < b.nom)
	else:
		eleves.sort_custom(func(a,b): return a.nom > b.nom)
	return true

## Nom est-il dans la liste des positifs de eleves[indice] ?
func positif_existe(indice: int, nom: String) -> bool:
	return eleves[indice].positifs.has(nom)

## Nom est ajouté à la liste des positifs de eleves[indice]
func ajouter_positif(indice: int, nom: String) -> void:
	eleves[indice].positifs.append(nom)

## Nom est enlevé de la liste des positifs de eleves[indice]
func enlever_positif(indice: int, nom: String) -> void:
	eleves[indice].positifs.erase(nom)

## Nom est-il dans la liste des negatifs de eleves[indice] ?
func negatif_existe(indice: int, nom: String) -> int:
	return eleves[indice].negatifs.has(nom)

## Nom est ajouté à la liste des negatifs de eleves[indice]
func ajouter_negatif(indice: int, nom: String) -> void:
	eleves[indice].negatifs.append(nom)

## Nom est enlevé de la liste des negatifs de eleves[indice]	
func enlever_negatif(indice: int, nom: String) -> void:
	eleves[indice].negatifs.erase(nom)

## Efface toutes les listes d'affinités de chaque élève
func effacer_toutes_affinites() -> void:
	for eleve in eleves:
		eleve.positifs.clear()
		eleve.negatifs.clear()

## Retourne la liste des élèves appréciés par l'élève dont l'indice est donné
func liste_positifs(indice: int) -> Array[String]:
	return eleves[indice].positifs.duplicate()

## Retourne la liste des élèves peu appréciés par l'élève dont l'indice est donné
func liste_negatifs(indice: int) -> Array[String]:
	return eleves[indice].negatifs.duplicate()

## Retourne les indices des élèves appréciés par l'élève dont l'indice est donné
func evalue_positif(indice: int) -> Array:
	return liste_positifs(indice).map(func(e): return trouver_indice_eleve(e))

## Retourne les indices des élèves peu appréciés par l'élève dont l'indice est donné
func evalue_negatif(indice: int) -> Array:
	return liste_negatifs(indice).map(func(e): return trouver_indice_eleve(e))

## Retourne la liste des élèves appreciant l'élève dont le nom est donné	
func est_positif_pour(nom: String) -> Array[int]:
	var liste: Array[int] = []
	for n in get_nb_eleves():
		if eleves[n].positifs.has(nom):
			liste.append(n)
	return liste
	
## Retourne la liste des élèves n'appreciant pas l'élève dont le nom est donné	
func est_negatif_pour(nom: String) -> Array[int]:
	var liste: Array[int] = []
	for n in get_nb_eleves():
		if eleves[n].negatifs.has(nom):
			liste.append(n)
	return liste

## Retourne la popularité de l'élève nommé
func popularite(nom: String) -> int:
	return est_positif_pour(nom).size() - est_negatif_pour(nom).size()
		
## Définit une nouvelle position de la table de l'élève
func set_pos_eleve(indice: int, pos: Vector2) -> void:
	eleves[indice].table.pos = pos

## Retourne la position de la table de l'élève
func get_pos_eleve(indice: int) -> Vector2:
	return eleves[indice].table.pos

## Définit les positions de tous les élèves
func set_pos_tous_eleves(positions: Array) -> void:
	if positions.size() == eleves.size():
		for n in get_nb_eleves():
			eleves[n].table.pos = positions[n]

## Retourne les positions de tous les élèves		
func get_pos_tous_eleves() -> Array:
	return eleves.map(func(e): return e.table.pos)

## Définit un nouvel angle de la table de l'élève
func set_angle_eleve(indice: int, angle_degres: float) -> void:
	eleves[indice].table.angle = angle_degres

## Retourne l'angle de la table de l'élève	
func get_angle_eleve(indice: int) -> float:
	return eleves[indice].table.angle

## Applique une symétrie centrale à la position de tous les élèves tout en conservant
## l'orientation du texte 
func set_pos_eleves_sym_c(centre: Vector2) -> void:
	return eleves.map(func(e): e.table.pos = 2 * centre - e.table.pos)

## Retourne les coordonnées des élèves disposés avec au centre le plus populaire 
## si true, sinon le moins populaire au centre
func positions_sur_cercles(centre: Vector2, rayon_max: float, meilleur: bool = true) -> Array[Vector2]:
	# intialisation en classant les eleves par popularite
	var N = get_nb_eleves()
	var pops: Array[Array] = []
	var cercles: Array[int]
	for n in N:
		var pop: int = Globals.section.popularite(eleves[n].nom)
		if not cercles.has(pop): cercles.append(pop)
		pops.append([n, pop])
	pops.sort_custom((func(a, b): return a[1] > b[1]))
	cercles.sort()
	# assigner les coordonnées sur chaque cercle
	var positions: Array[Vector2] = Utiles.nouvelle_array_vector2(N)
	var unite_de_pop: float = floorf(rayon_max / cercles.size())
	for n in N:
		var cercle: float = cercles.find(pops[n][1]) * unite_de_pop
		var posx: float = rayon_max - cercle if meilleur else cercle
		var pos: Vector2 = Vector2(posx, 0).rotated(0.8 * n)
		positions[pops[n][0]] = pos + centre
	return positions

## Retourne toutes les combinaisons de tables d'élèves tirées en round-robin
## (une Array par séance), nécessite un nombre d'élèves paire pour bien fonctionner
func paires_tournantes() -> Array[Array]:
	var N: int = get_nb_eleves()
	if N <= 2: return []
	# Determiner les élèves en binome / evite des fonctions pour le faire faire explictement au prof
	var actuelles: Array = get_pos_angles_tous_eleves()
	var nouvelles: Array = []
	while actuelles.size() > 1:
		nouvelles.append(actuelles.back())
		var distances: Array = actuelles.map(func(a): actuelles.back().pos.distance_to(a.pos))
		distances.pop_back()
		var indice_paire: int = distances.find(distances.min())
		nouvelles.append(actuelles[indice_paire])
		actuelles.pop_back()
		actuelles.pop_at(indice_paire)
	nouvelles.append_array(actuelles)
	# https://fr.wikipedia.org/wiki/Tournoi_toutes_rondes
	var tables_tournantes: Array[Array] = []
	for  i in (N - 1):
		tables_tournantes.append(nouvelles)
		nouvelles = [nouvelles[0]] + [nouvelles[-1]] + nouvelles.slice(1, -1)
	return tables_tournantes

## Retourne les tables, soit positions et angles de tous les élèves de la liste	
func get_pos_angles_tous_eleves() -> Array:
	return eleves.map(func(e): return e.table)

## Donne une table, soit une position et un angle à tous les élèves de la liste	
func set_pos_angles_tous_eleves(tables: Array) -> void:
	for i in get_nb_eleves():
		eleves[i].table = tables[i]

## Obtenir le nombre de table vierges
func get_nb_tables_vierges() -> int:
	return tables_vierges.size()

## Créer une nouvelle table vierge, ajoutée à la fin de la liste des tables positionnées en décalage
func ajouter_table_vierge() -> void:
	var nouveau: Table = Table.new()
	nouveau.pos = 2 * taille_table + Vector2(1,3) * get_nb_tables_vierges()
	tables_vierges.append(nouveau)

## Enlève la dernière table de la liste des tables
func enlever_derniere_table_vierge() -> void:
	tables_vierges.pop_back()

## Definis une nouvelle position pour la table vierge
func set_pos_table_vierge(indice: int, pos: Vector2) -> void:
	tables_vierges[indice].pos = pos

## Retourne la position de la table vierge	
func get_pos_table_vierge(indice: int) -> Vector2:
	return tables_vierges[indice].pos
	
## Retourne les positions de tous les élèves		
func get_pos_toutes_tables_vierges() -> Array:
	return tables_vierges.map(func(t): return t.pos)

## Definis un nouvel angle pour la table vierge		
func set_angle_table_vierge(indice: int, angle_degres: float) -> void:
	tables_vierges[indice].angle = angle_degres

## Retourne l'angle de la table vierge	
func get_angle_table_vierge(indice: int) -> float:
	return tables_vierges[indice].angle
	
## Applique une symétrie centrale à toutes les tables de la liste	
func set_pos_tables_sym_c(centre: Vector2) -> void:
	for t in tables_vierges:
		t.pos = 2 * centre - t.pos

## Retourne un rectangle englobant les centres de toutes les tables, avec ou sans élèves
func get_pos_min_max() -> Rect2:
	if eleves.is_empty() and tables_vierges.is_empty():
		return Rect2(Vector2.ZERO, Vector2.ZERO)
	var positions: Array = get_pos_tous_eleves() + get_pos_toutes_tables_vierges()
	var x: Array = positions.map(func(e): return e.x)
	var y: Array = positions.map(func(e): return e.y)
	return Rect2(x.min(), y.min(), x.max() - x.min(), y.max() - y.min())
